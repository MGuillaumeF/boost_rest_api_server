#include "LoggerConsole.hpp"

/**
 * To write a log message
 * @param msg The message to print
 */
void LoggerConsole::write(const std::string &msg)
{
    std::cout << msg << std::endl;
}
/**
 * Destructor of Logger
 */
LoggerConsole::~LoggerConsole()
{

}