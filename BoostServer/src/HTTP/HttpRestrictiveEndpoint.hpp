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
  
  void doGet() { writeNotImplementedResponse(); }
  
  void doPost() { writeNotImplementedResponse(); }
  
  void doPut() { writeNotImplementedResponse(); }
  
  void doDelete() { writeNotImplementedResponse(); }
  
  void doPatch() { writeNotImplementedResponse(); }

protected:

  http::request<Body, http::basic_fields<Allocator>> m_request;

  Send m_send;
  std::map<int, bool> m_allowedMethods;
  
 void writeMethodNotAllowed() {
    http::response<http::string_body> res{http::status::method_not_allowed,
                                          m_request.version()};
    res.set(http::field::server, BOOST_BEAST_VERSION_STRING);
    res.set(http::field::content_type, "text/html");
    res.keep_alive(m_request.keep_alive());
    res.body() = "The method is not allowed.";
    res.prepare_payload();
    m_send(res);
  }

  
  void writeNotImplementedResponse() {
    http::response<http::string_body> res{http::status::not_implemented,
                                          m_request.version()};
    res.set(http::field::server, BOOST_BEAST_VERSION_STRING);
    res.set(http::field::content_type, "text/html");
    res.keep_alive(m_request.keep_alive());
    res.body() = "The method is not implemented.";
    res.prepare_payload();
    m_send(res);
  }

  void handleRequest() {
    try {
      if (m_allowedMethods.at(m_request.method())) {
        switch (m_request.method()) {
        case http::verb::post:
          doPost();
          break;
        case http::verb::get:
          doGet();
          break;
        case http::verb::put:
          doPut();
          break;
        case http::verb::patch:
          doPatch();
          break;
        case http::verb::delete_:
          doDelete();
          break;
        default:
          writeNotImplementedResponse();
        }
      } else {
        writeMethodNotAllowed();
      }
    } catch (std::out_of_range) {
      writeMethodNotAllowed();
    }
  }

public:
  /**
   * HTTP Endpoint where all method is not allowed by default
   */
  HttpRestrictiveEndpoint(
      http::request<Body, http::basic_fields<Allocator>> &&req, Send &&send,
      bool allowPost = false, bool allowGet = false, bool allowPut = false,
      bool allowPatch = false, bool allowDelete = false)
      : m_request(req), m_send(send) {

    m_allowedMethods = {{http::verb::post, allowPost},
                        {http::verb::get, allowGet},
                        {http::verb::put, allowPut},
                        {http::verb::patch, allowPatch},
                        {http::verb::delete_, allowDelete}};
    handleRequest();
  };
  /**
   * HTTP Endpoint where all method is not allowed by default
   */
  HttpRestrictiveEndpoint(
      http::request<Body, http::basic_fields<Allocator>> &&req, Send &&send,
      std::map<int, bool> allowedMathods)
      : m_request(req), m_send(send), m_allowedMethods(allowedMathods) {

    handleRequest();
  };

  ~HttpRestrictiveEndpoint() {}
};

#endif // __HTTP_RESTRICTIVE_ENDPOINT_HPP__