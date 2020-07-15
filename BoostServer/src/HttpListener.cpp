#include "HttpListener.hpp"

HttpListener::HttpListener(
        net::io_context& ioc,
        tcp::endpoint endpoint,
        std::shared_ptr<std::string const> const& doc_root)
        : m_ioc(ioc)
        , m_acceptor(net::make_strand(ioc))
        , m_doc_root(doc_root)
    {
        beast::error_code ec;

        // Open the acceptor
        m_acceptor.open(endpoint.protocol(), ec);
        if(ec)
        {
            HttpUtils::onFail(ec, "open");
            return;
        }

        // Allow address reuse
        m_acceptor.set_option(net::socket_base::reuse_address(true), ec);
        if(ec)
        {
            HttpUtils::onFail(ec, "set_option");
            return;
        }

        // Bind to the server address
        m_acceptor.bind(endpoint, ec);
        if(ec)
        {
            HttpUtils::onFail(ec, "bind");
            return;
        }

        // Start listening for connections
        m_acceptor.listen(
            net::socket_base::max_listen_connections, ec);
        if(ec)
        {
            HttpUtils::onFail(ec, "listen");
            return;
        }
    }


// Start accepting incoming connections
void HttpListener::run()
{
    doAccept();
}

void HttpListener::doAccept()
{
    // The new connection gets its own strand
    m_acceptor.async_accept(
        net::make_strand(m_ioc),
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
        std::make_shared<HttpSession>(
            std::move(socket),
            m_doc_root)->run();
    }

    // Accept another connection
    doAccept();
}