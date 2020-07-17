#ifndef __LOGGER_H__
#define __LOGGER_H__

#include <string>

/**
 * All level available for logs
 */
enum LEVEL
{
    DEBUG = 0,
    INFO,
    WARN,
    ERROR
};

/**
 * class for log 
 */
class Logger
{
private:
    /**
     * The log Level
     * @see LEVEL
     */
    int m_level = 1;

public:
    /**
     * To get the log level of Logger
     */
    int getLevel();
    /**
     * To set the log level of Logger
     * @param level The new level of logger
     */
    void setLevel(int level);
    /**
     * To print debug log
     * @param msg The message to print
     */
    void debug(const std::string &msg);
    /**
     * To print info log
     * @param msg The message to print
     */
    void info(const std::string &msg);
    /**
     * To print warn log
     * @param msg The message to print
     */
    void warn(const std::string &msg);
    /**
     * To print error log
     * @param msg The message to print
     */
    void error(const std::string &msg);
    /**
     * To write a log message
     * @param msg The message to print
     */
    virtual void write(const std::string &msg) = 0;
};

#endif // __LOGGER_H__