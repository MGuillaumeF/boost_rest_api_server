#ifndef __LOGGERFILE_H__
#define __LOGGERFILE_H__

#include <string>
#include <fstream>
#include "Logger.hpp"

/**
 * class for log in file
 */
class LoggerFile : public Logger
{
private:
    /**
     * 
     */
    std::fstream m_fs;
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