#include "LoggerFile.hpp"
/**
 * Contructor of Logger
 */
LoggerFile::LoggerFile()
{
    m_fs.open("logfile.log", std::fstream::in | std::fstream::out | std::fstream::app);
}
/**
 * To write a log message
 * @param msg The message to print
 */
void LoggerFile::write(const std::string &msg)
{
    m_fs << msg << std::endl;
}
/**
 * Destructor of Logger
 */
LoggerFile::~LoggerFile()
{
    m_fs.close();
}