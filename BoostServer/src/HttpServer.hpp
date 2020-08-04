#include "HttpListener.hpp"
#include <thread>
/**
 * hello3
 */
class HttpServer {
public:
  HttpServer(char *address, char *port, char *doc_root, char *threads);
  ~HttpServer() {}
};