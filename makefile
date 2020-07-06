CC = clang++
CFLAGS = -stdlib=libc++ -std=c++11 -Wall
EXEC_NAME = BoostServer
INCLUDES = -I/user/local/include
LIBS =
OBJ_DIR = obj
OBJ_FILES = HttpUtils.o HttpSession.o HttpListener.o HttpServer.o
INSTALL_DIR = bin

all : $(EXEC_NAME)

$(EXEC_NAME) : $(OBJ_FILES)
	mkdir $(INSTALL_DIR) || echo "$(INSTALL_DIR) exist"
	mkdir $(INSTALL_DIR)/$(OBJ_DIR) || echo "$(OBJ_DIR) exist"
	$(CC) -o $(INSTALL_DIR)/$(EXEC_NAME) $(OBJ_FILES) $(LIBS)
	mv $(OBJ_FILES) $(INSTALL_DIR)/$(OBJ_DIR)/

%.o: %.cpp
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<
%.o: %.cc
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<
%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<

clean : 
	rm $(INSTALL_DIR)/$(EXEC_NAME) || echo "$(INSTALL_DIR)/$(EXEC_NAME) not exist"
	rmdir $(INSTALL_DIR)/$(OBJ_DIR) || echo "$(OBJ_DIR) not exist"
	rmdir $(INSTALL_DIR) || echo "$(INSTALL_DIR) not exist"
	rm -rf *.gcno

test : $(TARGET) $(addprefix run-,$(Target))
	make -C ./tests test

coverage :
	rm -rf coverage-report
	lcov --zerocounters --directory .
	$(CC) -o $(INSTALL_DIR)/testHttpUtils $(INSTALL_DIR)/obj/*.o $(LIBS)
	$(MAKE) COMPILE_TYPE=code_coverage
	$(MAKE) COMPILE_TYPE=code_coverage test
	$(INSTALL_DIR)/testHttpUtils --log_level=test_suite
	lcov --capture --directory $(INSTALL_DIR)/$(OBJ_DIR)/code_coverage --base-directory . -o salida.out
	lcov --remove salida.out "*usr/include*" -o salida.oout
	genhtml -o coverage_report salida.out
	rm salida.out
