CC = clang++
CFLAGS = -stdlib=libc++ -std=c++11 -Wall
EXEC_NAME = BoostServer
INCLUDES = -I/user/local/include
LIBS =
OBJ_DIR = ./obj
OBJ_FILES = http_server_async.o
INSTALL_DIR = ./bin

all : $(EXEC_NAME)

$(EXEC_NAME) : $(OBJ_FILES)
	mkdir $(INSTALL_DIR)
	$(CC) -o $(INSTALL_DIR)/$(EXEC_NAME) $(OBJ_FILES) $(LIBS)

%.o: %.cpp
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<
%.o: %.cc
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<
%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<

clean : 
	rm $(INSTALL_DIR)/$(EXEC_NAME)
	rm $(OBJ_FILES)
	rmdir $(INSTALL_DIR)
	rmdir $(OBJ_DIR)