CC = clang++
CFLAGS = -stdlib=libc++ -std=c++11 -Wall
EXEC_NAME = BoostServer
INCLUDES = -I/user/local/include
LIBS =
OBJ_DIR = obj
OBJ_FILES = src/HttpUtils.o src/HttpSession.o src/HttpListener.o src/HttpServer.o src/main.o
INSTALL_DIR = bin

all : $(EXEC_NAME)

$(EXEC_NAME) : $(OBJ_FILES)
	mkdir $(INSTALL_DIR) || echo "$(INSTALL_DIR) directory already exist"
	mkdir $(INSTALL_DIR)/$(OBJ_DIR) || echo "$(INSTALL_DIR)/$(OBJ_DIR) directory already exist"
	$(CC) -o $(INSTALL_DIR)/$(EXEC_NAME) $(OBJ_FILES) $(LIBS)
	mv $(OBJ_FILES) $(INSTALL_DIR)/$(OBJ_DIR)/
%.o: %.cpp
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<
%.o: %.cc
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<
%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<

clean : 
	rm -rf $(INSTALL_DIR)/$(EXEC_NAME)
	rm -rf $(INSTALL_DIR)/$(OBJ_DIR)/*.o
	rm -rf $(INSTALL_DIR)/testHttpUtils
	rm -rf ./report/resultTU.xml
	rm -rf ./report/resultCoverage.info
	rm -rf *.gcda
	rm -rf *.gcno
	rmdir $(INSTALL_DIR)/$(OBJ_DIR) || echo "$(OBJ_DIR) directory not exist"
	rmdir $(INSTALL_DIR) || echo "$(INSTALL_DIR) directory not exist"
test :
	mkdir ./report || echo report directory already exist
	$(CC) -o $(INSTALL_DIR)/testHttpUtils ./bin/obj/Http* ./tests/testHttpUtils.cpp $(LIBS) $(CFLAGS) -lboost_unit_test_framework --coverage
	./$(INSTALL_DIR)/testHttpUtils --log_level=test_suite --log_format=XML > ./report/resultTU.xml
coverage :
	mkdir ./report || echo report directory already exist
	lcov --directory . -c -o ./report/resultCoverage.info --no-external
	genhtml -o ./report/coverage -t "test_titre" ./report/resultCoverage.info
	rm -rf *.gcda
	rm -rf *.gcno