#ifndef __LOGGERCONSOLE_H__
#define __LOGGERCONSOLE_H__

#include <string>
#include <iostream>
#include "Logger.hpp"

/**
 * class for log in console
 */
class LoggerConsole : public Logger
{
public:
    /**
     * To write a log message
     * @param msg The message to print
     */
    void write(const std::string &msg);
    /**
     * Destructor of Logger
     */
    ~LoggerConsole();
};

#endif // __LOGGERCONSOLE_H__