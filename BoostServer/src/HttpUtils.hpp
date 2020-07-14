#ifndef __HTTP_UTILS_H__
#define __HTTP_UTILS_H__

#include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>
#include <boost/beast/version.hpp>
#include <boost/asio/dispatch.hpp>
#include <boost/asio/strand.hpp>
#include <boost/config.hpp>
#include <algorithm>
#include <cstdlib>
#include <functional>
#include <iostream>
#include <memory>
#include <string>
#include <thread>
#include <vector>

namespace beast = boost::beast;         // from <boost/beast.hpp>
namespace http = beast::http;           // from <boost/beast/http.hpp>
namespace net = boost::asio;            // from <boost/asio.hpp>

using tcp = boost::asio::ip::tcp;       // from <boost/asio/ip/tcp.hpp>

class HttpUtils {
    public :
    /**
     * The default constructor of Utils class
     */
    HttpUtils();
    
    /**
     *  Return a reasonable mime type based on the extension of a file.
     * @param path the path of request
     * @return the mime-type of file
     */
    static beast::string_view getMimeType(beast::string_view path);
    
    /**
     * Report a failure
     * @param ec the error code
     * @param what the explanation of error
     */
    static void onFail(beast::error_code ec, char const* what);
    
    /**
     * The default destructor of Utils class
     */
    ~HttpUtils();
};

#endif