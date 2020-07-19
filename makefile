CC = clang++
OS_PM = brew
CFLAGS = -stdlib=libc++ -std=c++11 -Wall
EXEC_NAME = BoostServer
INCLUDES = -I/user/local/include
LIBS =
INSTALL_DIR = bin
SOURCES_DIR = BoostServer/src
OBJ_DIR = $(INSTALL_DIR)/obj
DOC_DIR = docs
REPORT_DIR = report
TEST_EXEC = BoostServerTest

# All Logger object files
LOGGER_OBJ_FILES = $(OBJ_DIR)/Logger/Logger.o $(OBJ_DIR)/Logger/LoggerConsole.o $(OBJ_DIR)/Logger/LoggerFile.o 

# All Obj files of project
OBJ_FILES = $(OBJ_DIR)/HttpUtils.o $(OBJ_DIR)/HttpSession.o $(OBJ_DIR)/HttpListener.o $(OBJ_DIR)/HttpServer.o $(LOGGER_OBJ_FILES) $(OBJ_DIR)/main.o

# All Logger sources files
LOGGER_SOURCES_FILES = $(SOURCES_DIR)/Logger/Logger.hpp $(SOURCES_DIR)/Logger/Logger.cpp $(SOURCES_DIR)/Logger/LoggerConsole.hpp $(SOURCES_DIR)/Logger/LoggerConsole.cpp $(SOURCES_DIR)/Logger/LoggerFile.hpp $(SOURCES_DIR)/Logger/LoggerFile.cpp

# All sources files without main.cpp for test compilation
SOURCES_FILES = $(SOURCES_DIR)/HttpUtils.hpp $(SOURCES_DIR)/HttpUtils.cpp $(SOURCES_DIR)/HttpListener.hpp $(SOURCES_DIR)/HttpListener.cpp $(SOURCES_DIR)/HttpSession.hpp $(SOURCES_DIR)/HttpSession.cpp $(SOURCES_DIR)/HttpServer.hpp $(SOURCES_DIR)/HttpServer.cpp $(LOGGER_SOURCES_FILES)

all : $(EXEC_NAME)

$(EXEC_NAME) : $(OBJ_FILES)
	$(CC) -o $(INSTALL_DIR)/$(EXEC_NAME) $(OBJ_FILES) $(LIBS)
$(OBJ_DIR)/%.o: $(SOURCES_DIR)/%.cpp
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<
$(OBJ_DIR)/%.o: $(SOURCES_DIR)/%.cc
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<
$(OBJ_DIR)/%.o: $(SOURCES_DIR)/%.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<

install :
	$(OS_PM) install wget --verbose
	wget https://dl.bintray.com/boostorg/release/1.73.0/source/boost_1_73_0.tar.bz2
	tar --bzip2 -xf ./boost_1_73_0.tar.bz2
	cd ./boost_1_73_0; ./bootstrap.sh; \
	./b2 toolset=clang threading=multi runtime-link=static  link=static cxxflags="-stdlib=libc++ -std=c++11" linkflags="-stdlib=libc++" address-model=64; \
	./b2 install
	rm -r boost_1_73_0
	rm -rf boost_1_73_0.tar.bz2
	$(OS_PM) install llvm --verbose
	$(OS_PM) install lcov --verbose
	$(OS_PM) install doxygen --verbose
	$(OS_PM) install graphviz --verbose

prepare :
	mkdir $(INSTALL_DIR) || echo "$(INSTALL_DIR) directory already exist"
	mkdir $(OBJ_DIR) || echo "$(OBJ_DIR) directory already exist"
	mkdir $(OBJ_DIR)/Logger || echo "$(OBJ_DIR)/Logger directory already exist"
clean : 
	rm -rf $(INSTALL_DIR)/$(EXEC_NAME)
	rm -rf $(OBJ_DIR)/*.o
	rm -rf $(OBJ_DIR)/Logger/*.o
	rm -rf $(INSTALL_DIR)/$(TEST_EXEC)
	rm -rf $(REPORT_DIR)/resultTU.xml
	rm -rf $(REPORT_DIR)/resultCoverage.info
	rm -rf *.gcda
	rm -rf *.gcno
	rm -rf *.log
	rm -rf $(SOURCES_DIR)/*.gch
	rm -rf $(SOURCES_DIR)/Logger/*.gch
purge :
	$(MAKE) clean
	rm -r $(DOC_DIR) || echo "$(DOC_DIR) directory not exist"
	rm -r $(REPORT_DIR) || echo "$(REPORT_DIR) directory not exist"
	rm -r $(INSTALL_DIR) || echo "$(INSTALL_DIR) directory not exist"
test :
	rm -r $(REPORT_DIR) || echo "$(REPORT_DIR) directory not exist"
	mkdir $(REPORT_DIR) || echo $(REPORT_DIR) directory already exist
	$(CC) $(SOURCES_FILES) ./BoostServer/tests/* $(LIBS) $(CFLAGS) -lboost_unit_test_framework --coverage
	./a.out --log_level=test_suite --log_format=XML > $(REPORT_DIR)/resultTU.xml
	rm -rf testHttpUtils.gcda
	rm -rf testHttpUtils.gcno
	lcov --directory . -c -o $(REPORT_DIR)/resultCoverage.info --no-external
	genhtml --highlight --legend --output-directory $(REPORT_DIR)/coverage -t "Boost Server coverage report" $(REPORT_DIR)/resultCoverage.info
	rm -rf *.gcda
	rm -rf *.gcno
	rm -rf a.out
	rm -rf $(SOURCES_DIR)/*.gch
	rm -rf $(SOURCES_DIR)/Logger/*.gch
doc :
	rm -r $(DOC_DIR) || echo "$(DOC_DIR) directory not exist"
	doxygen docg.conf
package : 
	$(MAKE) purge
	$(MAKE) doc
	$(MAKE) prepare
	$(MAKE) all
	$(MAKE) test
	mv report ./docs