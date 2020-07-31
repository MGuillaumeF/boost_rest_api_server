# BoostServer Project

## Description of BoostServer Project

This project is an example of HTTP Server Designed with Boost Library.

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
