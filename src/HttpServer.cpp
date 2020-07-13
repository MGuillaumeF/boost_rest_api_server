#include "HttpListener.h"

void runServer(char* address, char* port, char* doc_root, char* threads) {
    auto const l_address = net::ip::make_address(address);
    auto const l_port = static_cast<unsigned short>(std::atoi(port));
    auto const l_doc_root = std::make_shared<std::string>(doc_root);
    auto const l_threads = std::max<int>(1, std::atoi(threads));

    // The io_context is required for all I/O
    net::io_context ioc{l_threads};

    // Create and launch a listening port
    std::make_shared<listener>(
        ioc,
        tcp::endpoint{l_address, l_port},
        l_doc_root)->run();

    // Run the I/O service on the requested number of threads
    std::vector<std::thread> v;
    v.reserve(l_threads - 1);
    for(auto i = l_threads - 1; i > 0; --i)
        v.emplace_back(
        [&ioc]
        {
            ioc.run();
        });
    ioc.run();
}

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
    runServer(
        argv[1],
        argv[2],
        argv[3],
        argv[4]
        );

    return EXIT_SUCCESS;
}