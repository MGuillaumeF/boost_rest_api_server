#include "HttpServer.h"

int main(int argc, char* argv[])
{
    // Check command line arguments.
    if (argc != 5)
    {
        std::cerr <<
            "Usage: HttpServer <address> <port> <doc_root> <threads>\n" <<
            "Example:\n" <<
            "    HttpServer 0.0.0.0 8080 . 1\n";
        return EXIT_FAILURE;
    }
    HttpServer server = HttpServer(
        argv[1],
        argv[2],
        argv[3],
        argv[4]
        );

    return EXIT_SUCCESS;
}