#include <thread>
#include "HttpListener.hpp"

class HttpServer {
    public :
    HttpServer(char* address, char* port, char* doc_root, char* threads);
    ~HttpServer(){}
};