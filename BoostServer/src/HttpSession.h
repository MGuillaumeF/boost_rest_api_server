#ifndef __HTTP_SESSION_H__
#define __HTTP_SESSION_H__

#include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>
#include <boost/beast/version.hpp>
#include <boost/asio/dispatch.hpp>
#include <boost/asio/strand.hpp>
#include <boost/config.hpp>
#include <algorithm>
#include <cstdlib>
#include <functional>
#include <iostream>
#include <memory>
#include <string>
#include <thread>
#include <vector>

#include "./HttpUtils.hpp"

namespace beast = boost::beast;         // from <boost/beast.hpp>
namespace http = beast::http;           // from <boost/beast/http.hpp>
namespace net = boost::asio;            // from <boost/asio.hpp>
using tcp = boost::asio::ip::tcp;       // from <boost/asio/ip/tcp.hpp>

// Handles an HTTP server connection
class session : public std::enable_shared_from_this<session>
{
    // This is the C++11 equivalent of a generic lambda.
    // The function object is used to send an HTTP message.
    struct send_lambda
    {
        session& self_;

        explicit
        send_lambda(session& self)
            : self_(self)
        {
        }

        template<bool isRequest, class Body, class Fields>
        void
        operator()(http::message<isRequest, Body, Fields>&& msg) const
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
                    &session::on_write,
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

public:
    // Take ownership of the stream
    session(
            tcp::socket&& socket,
            std::shared_ptr<std::string const> const& doc_root)
            : m_stream(std::move(socket))
            , m_doc_root(doc_root)
            , m_lambda(*this)
        {
        }

    // Start the asynchronous operation
    void run();

    void do_read();

    void on_read(
        beast::error_code ec,
        std::size_t bytes_transferred);

    void on_write(
        bool close,
        beast::error_code ec,
        std::size_t bytes_transferred);

    void do_close();
};

#endif