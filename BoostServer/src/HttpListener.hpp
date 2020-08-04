#ifndef __HTTP_LISTENER_H__
#define __HTTP_LISTENER_H__

#include <boost/asio/dispatch.hpp>
#include <boost/asio/strand.hpp>

#include "HttpSession.hpp"
#include "HttpUtils.hpp"

namespace net = boost::asio;      // from <boost/asio.hpp>
using tcp = boost::asio::ip::tcp; // from <boost/asio/ip/tcp.hpp>

/**
 *  Accepts incoming connections and launches the sessions
 */
class HttpListener : public std::enable_shared_from_this<HttpListener> {
  net::io_context &m_ioc;
  tcp::acceptor m_acceptor;
  std::shared_ptr<std::string const> m_doc_root;

public:
  /**
   * Constructor of class
   */
  HttpListener(net::io_context &ioc, tcp::endpoint endpoint,
               std::shared_ptr<std::string const> const &doc_root);

  /**
   * Start accepting incoming connections
   */
  void run();

private:
  /**
   * Dispatch new connection to gets its own strand
   */
  void doAccept();
  /**
   * Create the session for the new connection and run it
   */
  void onAccept(beast::error_code ec, tcp::socket socket);
};

#endif