#ifndef __HTTP_RESTRICTIVE_ENDPOINT_HPP__
#define __HTTP_RESTRICTIVE_ENDPOINT_HPP__

#include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>
#include <boost/beast/version.hpp>

/**
 * from <boost/beast.hpp>
 */
namespace beast = boost::beast;
/**
 * from <boost/beast/http.hpp>
 */
namespace http = beast::http;

/**
 * Http Endpoint Class ito create HTTP response
 */
template <class Body, class Allocator, class Send>
class HttpRestrictiveEndpoint {
private:
  bool m_postMethodAllowed;
  bool m_getMethodAllowed;
  bool m_putMethodAllowed;
  bool m_deleteMethodAllowed;
  bool m_patchMethodAllowed;

public:
  /**
   * HTTP Endpoint where all method is not allowed by default
   */
  HttpRestrictiveEndpoint(
      http::request<Body, http::basic_fields<Allocator>> &&req, Send &&send,
      bool allowPost = false, bool allowGet = false, bool allowPut = false,
      bool allowDelete = false, bool allowPatch = false) {
    m_postMethodAllowed = allowPost;
    m_getMethodAllowed = allowGet;
    m_putMethodAllowed = allowPut;
    m_deleteMethodAllowed = allowDelete;
    m_patchMethodAllowed = allowPatch;
    handleRequest(req, send);
  };

  void doGet(http::request<Body, http::basic_fields<Allocator>> &&req,
             Send &&send) {
    writeMethodNotAllowed(&req, &send);
  }
  void doPost(http::request<Body, http::basic_fields<Allocator>> &&req,
              Send &&send) {
    writeMethodNotAllowed(&req, &send);
  }
  void doPut(http::request<Body, http::basic_fields<Allocator>> &&req,
             Send &&send) {
    writeMethodNotAllowed(&req, &send);
  }
  void doDelete(http::request<Body, http::basic_fields<Allocator>> &&req,
                Send &&send) {
    writeMethodNotAllowed(&req, &send);
  }
  void doPatch(http::request<Body, http::basic_fields<Allocator>> &&req,
               Send &&send) {
    writeMethodNotAllowed(&req, &send);
  }

  void writeMethodNotAllowed(http::request<Body, http::basic_fields<Allocator>> &&req,
               Send &&send) {
    http::response<http::string_body> res{http::status::method_not_allowed,
                                          req.version()};
    res.set(http::field::server, BOOST_BEAST_VERSION_STRING);
    res.set(http::field::content_type, "text/html");
    res.keep_alive(req.keep_alive());
    res.body() = "The method is not allowed.";
    res.prepare_payload();
    send(res);
  }

  void writeNotImplementedResponse(http::request<Body, http::basic_fields<Allocator>> &&req,
               Send &&send) {
    http::response<http::string_body> res{http::status::not_implemented,
                                          req.version()};
    res.set(http::field::server, BOOST_BEAST_VERSION_STRING);
    res.set(http::field::content_type, "text/html");
    res.keep_alive(req.keep_alive());
    res.body() = "The method is not implemented.";
    res.prepare_payload();
    send(res);
  }

  void handleRequest(http::request<Body, http::basic_fields<Allocator>> &req,
                     Send &send) {
    if (m_postMethodAllowed && req.method() == http::verb::post) {
      doPost(&req, &send);
    } else if (m_getMethodAllowed && req.method() == http::verb::get) {
      doGet(&req, &send);
    } else if (m_putMethodAllowed && req.method() == http::verb::put) {
      doPut(&req, &send);
    } else if (m_deleteMethodAllowed && req.method() == http::verb::delete_) {
      doDelete(&req, &send);
    } else if (m_patchMethodAllowed && req.method() == http::verb::patch) {
      doPatch(&req, &send);
    } else {
      writeMethodNotAllowed(&req, &send);
    }
  }

  ~HttpRestrictiveEndpoint() {}
};

#endif // __HTTP_RESTRICTIVE_ENDPOINT_HPP__