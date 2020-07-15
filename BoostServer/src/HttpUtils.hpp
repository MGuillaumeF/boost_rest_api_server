#ifndef __HTTP_UTILS_H__
#define __HTTP_UTILS_H__

#include <boost/beast/core.hpp>
#include <iostream>

namespace beast = boost::beast;         // from <boost/beast.hpp>

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