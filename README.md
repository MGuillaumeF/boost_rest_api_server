# BoostServer Project

## Description of BoostServer Project

This project is an example of HTTP Server Designed with Boost Library.

This project use :

- [llvm](https://llvm.org) for clang compiler and LLD linker/debugger
- [lcov](https://wiki.documentfoundation.org/Development/Lcov) for code coverage by a libreoffice 
- [doxygen](https://www.doxygen.nl) for documentation generation (HTML, LaTex or man)
- [graphViz](https://graphviz.org) for graph generation of doxygen documentation (dependencies diagram, classes diagram, call diagram)
- [boost library](https://www.boost.org) version 1.73.0 for unit test and server fonctionnalities (HTTP Server, JSON read/write or WebSocket)

This example contain :

- Unit Tests with `Boost TEST`
- Unit Tests Coverage with `lcov`
- Code Documentation with `Doxygen` and `GraphViz`
- API Docuementation [TODO]

See [unit test coverage of project](./report/coverage/index.html)

## Command for project

```shell
# prepare all directories for build, tests and documentation
make prepare

# build project
make

# generate documentation of project
make doc

# generate boost test project and run test program with test and coverage report (raw, xml and html output)
make test

# remove temporaries files of old tests and build
make clean

# remove all build directories
make purge
```
