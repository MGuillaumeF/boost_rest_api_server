CC = clang++
CFLAGS = -stdlib=libc++ -std=c++11 -Wall
EXEC_NAME = BoostServer
INCLUDES = -I/user/local/include
LIBS =
OBJ_DIR = ./obj
OBJ_FILES = HttpUtils.o http_server_async.o
INSTALL_DIR = ./bin

all : $(EXEC_NAME)

$(EXEC_NAME) : $(OBJ_FILES)
	mkdir $(OBJ_DIR) || echo "$(OBJ_DIR) exist"
	mkdir $(INSTALL_DIR) || echo "$(INSTALL_DIR) exist"
	$(CC) -o $(INSTALL_DIR)/$(EXEC_NAME) $(OBJ_FILES) $(LIBS)
	mv $(OBJ_FILES) $(OBJ_DIR)/

%.o: %.cpp
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<
%.o: %.cc
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<
%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<

clean : 
	rm $(INSTALL_DIR)/$(EXEC_NAME) || echo "$(INSTALL_DIR)/$(EXEC_NAME) not exist"
	rm $(OBJ_FILES)
	rmdir $(INSTALL_DIR) || echo "$(INSTALL_DIR) not exist"
	rmdir $(OBJ_DIR) || echo "$(OBJ_DIR) not exist"