OS_FAMILY =
OS_ARCH =
OS_PM =

ifeq ($(OS), Windows_NT)
	OS_FAMILY = WIN32
	OS_PM = winget
	ifeq ($(PROCESSOR_ARCHITECTURE), AMD64)
		OS_ARCH = AMD64
	endif
	ifeq ($(PROCESSOR_ARCHITECTURE), x86)
		OS_ARCH = IA32
	endif
else
	UNAMES_S := $(shell uname -s)
	ifeq ($(UNAMES_S), Linux)
		OS_FAMILY = LINUX
		OS_PM = yum
	endif
	ifeq ($(UNAMES_S), Darwin)
		OS_FAMILY = OSX
		OS_PM = brew
	endif
	UNAMES_P := $(shell uname -p)
	ifeq ($(UNAMES_P), x86_64)
		OS_ARCH = AMD64
	endif
	ifneq ($(filter %86,$(UNAMES_P)),)
		OS_ARCH = IA32
	endif
	ifneq ($(filter arm%,$(UNAMES_P)),)
		OS_ARCH = ARM
	endif
endif

# Build configuration
CC = clang++
CFLAGS = -stdlib=libc++ -std=c++11 -Wall
INCLUDES = -I/user/local/include
LIBS =

# Directories definition
INSTALL_DIR = bin
SOURCES_DIR = BoostServer/src
OBJ_DIR = $(INSTALL_DIR)/obj
LOGS_DIR = $(INSTALL_DIR)/logs
DOC_DIR = docs
REPORT_DIR = report

# Exe names
EXEC_NAME = BoostServer
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
	$(CC) -o $(INSTALL_DIR)/$(EXEC_NAME) $(OBJ_FILES) $(LIBS) > ./$(LOGS_DIR)/compile.log
$(OBJ_DIR)/%.o: $(SOURCES_DIR)/%.cpp
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $< >> ./$(LOGS_DIR)/compile.log
$(OBJ_DIR)/%.o: $(SOURCES_DIR)/%.cc
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $< >> ./$(LOGS_DIR)/compile.log
$(OBJ_DIR)/%.o: $(SOURCES_DIR)/%.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $< >> ./$(LOGS_DIR)/compile.log

# Install all dependencies of project
install :
	$(OS_PM) install wget --verbose
	wget https://dl.bintray.com/boostorg/release/1.73.0/source/boost_1_73_0.tar.bz2
	tar --bzip2 -xf ./boost_1_73_0.tar.bz2
	cd ./boost_1_73_0; ./bootstrap.sh; \
	./b2 toolset=clang threading=multi runtime-link=static  link=static cxxflags="-stdlib=libc++ -std=c++11" linkflags="-stdlib=libc++" address-model=64; \
	./b2 install
	@rm -r boost_1_73_0
	@rm -rf boost_1_73_0.tar.bz2
	$(OS_PM) install llvm --verbose
	$(OS_PM) install lcov --verbose
	$(OS_PM) install doxygen --verbose
	$(OS_PM) install graphviz --verbose

prepare :
	@mkdir $(INSTALL_DIR) || echo "$(INSTALL_DIR) directory already exist"
	@mkdir $(OBJ_DIR) || echo "$(OBJ_DIR) directory already exist"
	@mkdir $(LOGS_DIR) || echo "$(LOGS_DIR) directory already exist"
	@mkdir $(OBJ_DIR)/Logger || echo "$(OBJ_DIR)/Logger directory already exist"

# Clean appplication executable and temp files
clean : 
	@rm -rf $(INSTALL_DIR)/$(EXEC_NAME)
	@rm -rf $(OBJ_DIR)/*.o
	@rm -rf $(OBJ_DIR)/Logger/*.o
	@rm -rf $(INSTALL_DIR)/$(TEST_EXEC)
	@rm -rf $(REPORT_DIR)/resultTU.xml
	@rm -rf $(REPORT_DIR)/resultCoverage.info
	@rm -rf *.gcda
	@rm -rf *.gcno
	@rm -rf *.log
	@rm -rf $(SOURCES_DIR)/*.gch
	@rm -rf $(SOURCES_DIR)/Logger/*.gch

# Clean compile files
# Delete report, logs, documentations and build directories
purge :
	$(MAKE) clean
	@rm -r $(REPORT_DIR) || echo "$(REPORT_DIR) directory not exist"
	@rm -r $(LOGS_DIR) || echo "$(LOGS_DIR) directory not exist"
	@rm -r $(DOC_DIR) || echo "$(DOC_DIR) directory not exist"
	@rm -r $(INSTALL_DIR) || echo "$(INSTALL_DIR) directory not exist"

# Clean report directory
# Build boost test application
# Run boost test application to obtain TU report znd coverages traces
# Delete coverage traces for boost test files
# Generate coverage information report
# Generate coverage html report
# Delete coverage traces
test :
	@rm -r $(REPORT_DIR) || echo "$(REPORT_DIR) directory not exist"
	@mkdir $(REPORT_DIR) || echo $(REPORT_DIR) directory already exist
	$(CC) $(SOURCES_FILES) ./BoostServer/tests/* $(LIBS) $(CFLAGS) -lboost_unit_test_framework --coverage > ./$(LOGS_DIR)/tests.log
	./a.out --log_level=test_suite --log_format=XML > $(REPORT_DIR)/resultTU.xml
	@rm -rf testHttpUtils.gcda
	@rm -rf testHttpUtils.gcno
	lcov --directory . -c -o $(REPORT_DIR)/resultCoverage.info --no-external  >> ./$(LOGS_DIR)/tests.log
	genhtml --highlight --legend --output-directory $(REPORT_DIR)/coverage -t "Boost Server coverage report" $(REPORT_DIR)/resultCoverage.info  >> ./$(LOGS_DIR)/tests.log
	@rm -rf *.gcda
	@rm -rf *.gcno
	@rm -rf a.out
	@rm -rf $(SOURCES_DIR)/*.gch
	@rm -rf $(SOURCES_DIR)/Logger/*.gch

# To generate the documentation with doxygen
doc :
	@rm -r $(DOC_DIR) || echo "$(DOC_DIR) directory not exist"
	doxygen docg.conf > ./$(LOGS_DIR)/doxygen_info.log

# To package application
# -> clean old build files
# -> generate documentation
# -> prepare directories
# -> build application
# -> test application
package : 
	@echo OS : $(OS_FAMILY)
	@echo PROCESSOR_ARCHITECTURE : $(OS_ARCH)
	$(MAKE) purge
	$(MAKE) prepare
	$(MAKE) doc
	$(MAKE) all
	$(MAKE) test
	mv report ./docs