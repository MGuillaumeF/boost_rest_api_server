CC = clang++
OSPM = brew
CFLAGS = -stdlib=libc++ -std=c++11 -Wall
EXEC_NAME = BoostServer
INCLUDES = -I/user/local/include
LIBS =
INSTALL_DIR = bin
SOURCES_DIR = BoostServer/src
OBJ_DIR = $(INSTALL_DIR)/obj
OBJ_FILES = $(OBJ_DIR)/HttpUtils.o $(OBJ_DIR)/HttpSession.o $(OBJ_DIR)/HttpListener.o $(OBJ_DIR)/HttpServer.o $(OBJ_DIR)/main.o
SOURCES_FILES = $(SOURCES_DIR)/HttpUtils.hpp $(SOURCES_DIR)/HttpUtils.cpp $(SOURCES_DIR)/HttpListener.hpp $(SOURCES_DIR)/HttpListener.cpp $(SOURCES_DIR)/HttpSession.hpp $(SOURCES_DIR)/HttpSession.cpp $(SOURCES_DIR)/HttpServer.hpp $(SOURCES_DIR)/HttpServer.cpp
REPORT_DIR = report
TEST_EXEC = BoostServerTest

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
	wget https://dl.bintray.com/boostorg/release/1.73.0/source/boost_1_73_0.tar.bz2
	tar --bzip2 -xf ./boost_1_73_0.tar.bz2
	cd ./boost_1_73_0; ./bootstrap.sh; \
	./b2 toolset=clang threading=multi runtime-link=static  link=static cxxflags="-stdlib=libc++ -std=c++11" linkflags="-stdlib=libc++" address-model=64; \
	./b2 install
	rm -r boost_1_73_0
	rm -rf boost_1_73_0.tar.bz2
	$(OSPM) install clangd llvm lcov genhtml doxygen --verbose

prepare :
	mkdir $(INSTALL_DIR) || echo "$(INSTALL_DIR) directory already exist"
	mkdir $(OBJ_DIR) || echo "$(OBJ_DIR) directory already exist"

clean : 
	rm -rf $(INSTALL_DIR)/$(EXEC_NAME)
	rm -rf $(OBJ_DIR)/*.o
	rm -rf $(INSTALL_DIR)/$(TEST_EXEC)
	rm -rf $(REPORT_DIR)/resultTU.xml
	rm -rf $(REPORT_DIR)/resultCoverage.info
	rm -rf *.gcda
	rm -rf *.gcno
purge :
	$(MAKE) clean
	rm -r $(REPORT_DIR) || echo "$(REPORT_DIR) directory not exist"
	rm -r $(INSTALL_DIR) || echo "$(INSTALL_DIR) directory not exist"
test :
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
doc :
	doxygen docg.conf
full : 
	$(MAKE) purge
	$(MAKE) doc
	$(MAKE) prepare
	$(MAKE) all
	$(MAKE) test