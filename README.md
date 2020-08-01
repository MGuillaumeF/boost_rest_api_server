# BoostServer Project

## Description of BoostServer Project

This project is an example of HTTP Server Designed with Boost Library.

This project use :

- [llvm](https://llvm.org) version 11.0.0 under [LLVM Release License](https://releases.llvm.org/2.8/LICENSE.TXT) for clang compiler and LLD linker/debugger
- [lcov](https://wiki.documentfoundation.org/Development/Lcov) version 1.14.1 under [GNU General Public License v2.0](https://github.com/linux-test-project/lcov/blob/master/COPYING) for code coverage by a libreoffice 
- [doxygen](https://www.doxygen.nl) version 1.8.18 under [GNU General Public License v2.0](https://www.doxygen.nl/index.html) for documentation generation (HTML, LaTex or man)
- [graphViz](https://graphviz.org) version 2.42.1 under [Eclipse Public License 1.0](https://www.eclipse.org/legal/epl-v10.html) for graph generation of doxygen documentation (dependencies diagram, classes diagram, call diagram)
- [boost library](https://www.boost.org) version 1.73.0 under [Boost Sofware License](https://www.boost.org/LICENSE_1_0.txt) for unit test and server fonctionnalities (HTTP Server, JSON read/write or WebSocket)

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
