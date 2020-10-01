#ifndef __HTTP_FRUITS_ENDPOINT_HPP__
#define __HTTP_FRUITS_ENDPOINT_HPP__
#include "HttpRestrictiveEndpoint.hpp"

/**
 * Http Endpoint Class ito create HTTP response
 */
template <class Body, class Allocator, class Send>
class HttpFruitsEndpoint : public HttpRestrictiveEndpoint {


public:
    HttpFruitsEndpoint(http::request<Body, http::basic_fields<Allocator>> &&req, Send &&send) : HttpRestrictiveEndpoint(&req, &send, false, true) {

    }
  void doGet(http::request<Body, http::basic_fields<Allocator>> &&req,
             Send &&send) {
    http::response<http::string_body> res{http::status::ok,
                                          req.version()};
    res.set(http::field::server, BOOST_BEAST_VERSION_STRING);
    res.set(http::field::content_type, "text/html");
    res.keep_alive(req.keep_alive());
    res.body() = "This is a response";
    res.prepare_payload();
    send(res);
  }
};

#endif // __HTTP_FRUITS_ENDPOINT_HPP__