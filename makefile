CC = clang++
CFLAGS = -stdlib=libc++ -std=c++11 -Wall
EXEC_NAME = BoostServer
INCLUDES = -I/user/local/include
LIBS =
INSTALL_DIR = bin
SOURCES_DIR = BoostServer/src
OBJ_DIR = $(INSTALL_DIR)/obj
OBJ_FILES = $(OBJ_DIR)/HttpUtils.o $(OBJ_DIR)/HttpSession.o $(OBJ_DIR)/HttpListener.o $(OBJ_DIR)/HttpServer.o $(OBJ_DIR)/main.o
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
	rmdir $(OBJ_DIR) || echo "$(OBJ_DIR) directory not exist"
	rmdir $(INSTALL_DIR) || echo "$(INSTALL_DIR) directory not exist"
test :
	mkdir $(REPORT_DIR) || echo $(REPORT_DIR) directory already exist
	$(CC) -o $(INSTALL_DIR)/$(TEST_EXEC) ./bin/obj/Http* ./BoostServer/tests/* $(LIBS) $(CFLAGS) -lboost_unit_test_framework --coverage
	./$(INSTALL_DIR)/$(TEST_EXEC) --log_level=test_suite --log_format=XML > $(REPORT_DIR)/resultTU.xml
coverage :
	mkdir $(REPORT_DIR) || echo $(REPORT_DIR) directory already exist
	lcov --directory . -c -o $(REPORT_DIR)/resultCoverage.info --no-external
	genhtml --highlight --legend --output-directory $(REPORT_DIR)/coverage -t "Boost Server coverage report" $(REPORT_DIR)/resultCoverage.info
	rm -rf *.gcda
	rm -rf *.gcno

full : 
	$(MAKE) purge
	$(MAKE) prepare
	$(MAKE) all
	$(MAKE) test
	$(MAKE) coverage