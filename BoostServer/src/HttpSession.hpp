#ifndef __HTTP_SESSION_H__
#define __HTTP_SESSION_H__

#include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>
#include <boost/beast/version.hpp>
#include <boost/asio/dispatch.hpp>
#include <boost/asio/strand.hpp>
#include <boost/config.hpp>

#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/json_parser.hpp>

// Short alias for this namespace
namespace pt = boost::property_tree;

#include "HttpUtils.hpp"

/**
 * from <boost/beast.hpp>
 */
namespace beast = boost::beast; 
/**
 * from <boost/beast/http.hpp>
 */
namespace http = beast::http;
/**
 * from <boost/asio.hpp>    
 */
namespace net = boost::asio;
/**
 * from <boost/asio/ip/tcp.hpp>
 */
using tcp = boost::asio::ip::tcp;

/**
 * Handles an HTTP server connection
 */
class HttpSession : public std::enable_shared_from_this<HttpSession>
{
    // This is the C++11 equivalent of a generic lambda.
    // The function object is used to send an HTTP message.
    struct send_lambda
    {
        HttpSession &self_;

        explicit send_lambda(HttpSession &self)
            : self_(self)
        {
        }

        template <bool isRequest, class Body, class Fields>
        void operator()(http::message<isRequest, Body, Fields> &&msg) const
        {
            // The lifetime of the message has to extend
            // for the duration of the async operation so
            // we use a shared_ptr to manage it.
            auto sp = std::make_shared<
                http::message<isRequest, Body, Fields>>(std::move(msg));

            // Store a type-erased version of the shared
            // pointer in the class to keep it alive.
            self_.m_res = sp;

            // Write the response
            http::async_write(
                self_.m_stream,
                *sp,
                beast::bind_front_handler(
                    &HttpSession::onWrite,
                    self_.shared_from_this(),
                    sp->need_eof()));
        }
    };

    beast::tcp_stream m_stream;
    beast::flat_buffer m_buffer;
    std::shared_ptr<std::string const> m_doc_root;
    http::request<http::string_body> m_req;
    std::shared_ptr<void> m_res;
    send_lambda m_lambda;

    /** 
     * Append an HTTP rel-path to a local filesystem path.
     * The returned path is normalized for the platform.
     */
    std::string pathCat(beast::string_view base, beast::string_view path);

    /** 
     * This function produces an HTTP response for the given
     * request. The type of the response object depends on the
     * contents of the request, so the interface requires the
     * caller to pass a generic lambda for receiving the response.
     */
    template <class Body, class Allocator, class Send>
    void handleRequest(beast::string_view doc_root, http::request<Body, http::basic_fields<Allocator>> && req, Send && send);

public:
    // Take ownership of the stream
    HttpSession(
        tcp::socket &&socket,
        std::shared_ptr<std::string const> const &doc_root)
        : m_stream(std::move(socket)), m_doc_root(doc_root), m_lambda(*this)
    {
    }

    // Start the asynchronous operation
    void run();

    void doRead();

    void onRead(
        beast::error_code ec,
        std::size_t bytes_transferred);

    void onWrite(
        bool close,
        beast::error_code ec,
        std::size_t bytes_transferred);

    void doClose();
};

#endif