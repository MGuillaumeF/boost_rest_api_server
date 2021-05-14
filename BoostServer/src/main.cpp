#include "HttpServer.hpp"
// #include <boost/property_tree/ptree.hpp>
// #include <boost/property_tree/xml_parser.hpp>
#include "./Configuration/ConfigurationServer.hpp"
#include <iostream>

// struct Server {
//   std::string description;
//   std::string hostname;
//   std::string path;
//   unsigned short thread;
//   unsigned port;
// };

// typedef std::vector<Server> Servers;

int main(int argc, char *argv[]) {
  // Check command line arguments.
  if (argc != 5) {
    std::cerr << "Usage: HttpServer <address> <port> <doc_root> <threads>\n"
              << "Example:\n"
              << "    HttpServer 0.0.0.0 8080 . 1\n";
    return EXIT_FAILURE;
  }

  // boost::property_tree::ptree pt;
  // boost::property_tree::read_xml("../resources/configuration.xml", pt);

  // Servers confServers;
  // Server s;

  // boost::property_tree::ptree servers = pt.get_child("servers");
  // for (const boost::property_tree::ptree::value_type &kv : servers) {
  //   s.description = kv.second.get<std::string>("description");
  //   std::cerr << "description  : " << s.description << std::endl;
  // }
  // s.description = pt.get<std::string>("server.description");
  // std::cerr << "description  : " << s.description;
  // confServers.push_back(s);

  // If configuration of server is in arguments of execution
  // server is started
  ConfigurationServer config = ConfigurationServer(argv);
  HttpServer server = HttpServer(argv[1], argv[2], argv[3], argv[4]);

  return EXIT_SUCCESS;
}