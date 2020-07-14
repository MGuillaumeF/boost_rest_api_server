#include "HttpListener.h"

class HttpServer {
    public :
    HttpServer(char* address, char* port, char* doc_root, char* threads);
    ~HttpServer(){}
};