CC = clang++
CFLAGS = -stdlib=libc++ -std=c++11 -Wall
EXEC_NAME = BoostServer
INCLUDES = -I/user/local/include
LIBS =
OBJ_DIR = obj
OBJ_FILES = src/HttpUtils.o src/HttpSession.o src/HttpListener.o src/HttpServer.o
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

test : 
	$(CC) -o $(INSTALL_DIR)/testHttpUtils ./bin/obj/HttpUtils.o ./tests/testHttpUtils.cpp $(LIBS) $(CFLAGS) -lboost_unit_test_framework --coverage
	./$(INSTALL_DIR)/testHttpUtils --log_level=test_suite --log_format=XML > resultTU.xml
coverage :
	lcov --directory . -c -o rapport.info --no-external
	genhtml -o coverage_report -t "test_titre" rapport.info
