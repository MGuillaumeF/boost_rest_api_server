#include "HttpListener.hpp"

// Start accepting incoming connections
void HttpListener::run()
{
    doAccept();
}

void HttpListener::doAccept()
{
    // The new connection gets its own strand
    acceptor_.async_accept(
        net::make_strand(ioc_),
        beast::bind_front_handler(
            &HttpListener::onAccept,
            shared_from_this()));
}

void HttpListener::onAccept(beast::error_code ec, tcp::socket socket)
{
    if(ec)
    {
        HttpUtils::onFail(ec, "accept");
    }
    else
    {
        // Create the session and run it
        std::make_shared<session>(
            std::move(socket),
            doc_root_)->run();
    }

    // Accept another connection
    doAccept();
}