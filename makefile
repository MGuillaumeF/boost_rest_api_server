CC = g++
CFLAGS = -Wall
EXEC_NAME = BoostServer
INCLUDES = -I/Users/michelguillaume/Documents/Michel/code/boost_server/boost_1_73_0
LIBS = 
OBJ_FILES = http_server_async.cpp
INSTALL_DIR = /Users/michelguillaume/Documents/Michel/code/boost_server/bin

all : $(EXEC_NAME)

clean : 
	rm $(EXEC_NAME) $(OBJ_FILES)

$(EXEC_NAME) : $(OBJ_FILES)
	$(CC) -o $(EXEC_NAME) $(OBJ_FILES) $(LIBS)

%.o: %.cpp
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<
%.o: %.cc
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<
%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<

install : 
	cp $(EXEC_NAME) $(INSTALL_DIR)