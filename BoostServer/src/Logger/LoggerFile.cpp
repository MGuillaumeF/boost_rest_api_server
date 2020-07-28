#include "LoggerFile.hpp"
/**
 * Contructor of Logger
 */
LoggerFile::LoggerFile()
{
}
/**
 * To write a log message
 * @param msg The message to print
 */
void LoggerFile::write(const std::string &msg)
{
    std::fstream fs;
    fs.open("./logs/logfile.log", std::fstream::in | std::fstream::out | std::fstream::app);
    fs << msg << std::endl;
    fs.close();
}
/**
 * Destructor of Logger
 */
LoggerFile::~LoggerFile()
{
}