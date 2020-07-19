#ifndef __LOGGERFILE_H__
#define __LOGGERFILE_H__

/**
 * Logger is mother class of LoggerConsole
 */
#include "Logger.hpp"
/**
 * The string include is to message parameters of LoggerConsole
 */
#include <string>
/**
 * The fstream include is to print messages in file
 */
#include <fstream>

/**
 * Class for log in file
 */
class LoggerFile : public Logger
{
private:
    /**
     * To write a log message
     * @param msg The message to print
     */
    void write(const std::string &msg);
public:
    /**
     * Constructor of Logger
     */
    LoggerFile();
    /**
     * Destructor of Logger
     */
    ~LoggerFile();
};

#endif // __LOGGERFILE_H__