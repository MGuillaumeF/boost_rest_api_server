#include "./HttpUtils.h"

HttpUtils::HttpUtils() {}

// Return a reasonable mime type based on the extension of a file.
beast::string_view HttpUtils::getMimeType(beast::string_view path) {
  using beast::iequals;
  auto const ext = [&path] {
    auto const pos = path.rfind(".");
    if (pos == beast::string_view::npos)
      return beast::string_view{};
    return path.substr(pos);
  }();

  beast::string_view l_sMimeType = "application/text";

  if (iequals(ext, ".htm")) {
    l_sMimeType = "text/html";
  } else if (iequals(ext, ".html")) {
    l_sMimeType = "text/html";
  } else if (iequals(ext, ".php")) {
    l_sMimeType = "text/html";
  } else if (iequals(ext, ".css")) {
    l_sMimeType = "text/css";
  } else if (iequals(ext, ".txt")) {
    l_sMimeType = "text/plain";
  } else if (iequals(ext, ".js")) {
    l_sMimeType = "application/javascript";
  } else if (iequals(ext, ".json")) {
    l_sMimeType = "application/json";
  } else if (iequals(ext, ".xml")) {
    l_sMimeType = "application/xml";
  } else if (iequals(ext, ".swf")) {
    l_sMimeType = "application/x-shockwave-flash";
  } else if (iequals(ext, ".flv")) {
    l_sMimeType = "video/x-flv";
  } else if (iequals(ext, ".png")) {
    l_sMimeType = "image/png";
  } else if (iequals(ext, ".jpe")) {
    l_sMimeType = "image/jpeg";
  } else if (iequals(ext, ".jpeg")) {
    l_sMimeType = "image/jpeg";
  } else if (iequals(ext, ".jpg")) {
    l_sMimeType = "image/jpeg";
  } else if (iequals(ext, ".gif")) {
    l_sMimeType = "image/gif";
  } else if (iequals(ext, ".bmp")) {
    l_sMimeType = "image/bmp";
  } else if (iequals(ext, ".ico")) {
    l_sMimeType = "image/vnd.microsoft.icon";
  } else if (iequals(ext, ".tiff")) {
    l_sMimeType = "image/tiff";
  } else if (iequals(ext, ".tif")) {
    l_sMimeType = "image/tiff";
  } else if (iequals(ext, ".svg")) {
    l_sMimeType = "image/svg+xml";
  } else if (iequals(ext, ".svgz")) {
    l_sMimeType = "image/svg+xml";
  }
    std::cout << "MimeType of File found : " << l_sMimeType << std::endl;
  return l_sMimeType;
}

HttpUtils::~HttpUtils() {}