wget https://dl.bintray.com/boostorg/release/1.73.0/source/boost_1_73_0.tar.bz2
tar --bzip2 -xf ./boost_1_73_0.tar.bz2
cd ./boost_1_73_0/
./bootstrap.sh
./b2 toolset=clang threading=multi runtime-link=static  link=static cxxflags="-stdlib=libc++ -std=c++11" linkflags="-stdlib=libc++" address-model=64
./b2 install
brew install clangd llvm