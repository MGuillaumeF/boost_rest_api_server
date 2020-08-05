#include "HttpServer.hpp"
#include <iostream>

int main(int argc, char *argv[]) {
  // Check command line arguments.
  if (argc != 5) {
    std::cerr << "Usage: HttpServer <address> <port> <doc_root> <threads>\n"
              << "Example:\n"
              << "    HttpServer 0.0.0.0 8080 . 1\n";
    return EXIT_FAILURE;
  }
  try {
    // If configuration of server is in arguments of execution
    // server is started
    HttpServer server = HttpServer(argv[1], argv[2], argv[3], argv[4]);

  } catch (...) {
    std::cout << "Server stopped";
  }

  return EXIT_SUCCESS;
}