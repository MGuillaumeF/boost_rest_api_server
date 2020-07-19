#ifndef __LOGGERCONSOLE_H__
#define __LOGGERCONSOLE_H__

/**
 * Logger is mother class of LoggerConsole
 */
#include "Logger.hpp"
/**
 * The string include is to message parameters of LoggerConsole
 */
#include <string>
/**
 * The iostream include is to print messages in standard output or error output
 */
#include <iostream>

/**
 * class for log in console
 */
class LoggerConsole : public Logger
{
private:
    /**
     * To write a log message
     * @param msg The message to print
     */
    void write(const std::string &msg);
};

#endif // __LOGGERCONSOLE_H__