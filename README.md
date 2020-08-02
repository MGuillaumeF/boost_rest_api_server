# BoostServer Project

## Description of BoostServer Project

This project is an example of HTTP Server Designed with Boost Library.

This project use :

- [llvm](https://llvm.org) version 11.0.0 under [LLVM Release License](https://releases.llvm.org/2.8/LICENSE.TXT) for clang compiler and LLD linker/debugger
- [lcov](https://wiki.documentfoundation.org/Development/Lcov) version 1.14.1 under [GNU General Public License v2.0](https://github.com/linux-test-project/lcov/blob/master/COPYING) for code test coverage 
- [doxygen](https://www.doxygen.nl) version 1.8.18 under [GNU General Public License v2.0](https://www.doxygen.nl/index.html) for documentation generation (HTML, LaTex or man)
- [graphViz](https://graphviz.org) version 2.42.1 under [Eclipse Public License 1.0](https://www.eclipse.org/legal/epl-v10.html) for graph generation of doxygen documentation (dependencies diagram, classes diagram, call diagram)
- [boost library](https://www.boost.org) version 1.73.0 under [Boost Sofware License](https://www.boost.org/LICENSE_1_0.txt) for unit test and server fonctionnalities (HTTP Server, JSON read/write or WebSocket)

> See the [code coverage report of project](./report/coverage/index.html)

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
## Description du projet BoostServer

Ce projet est un exemple de serveur HTTP construit avec la librairie Boost.
Ce projet utilise :

- [llvm](https://llvm.org) version 11.0.0 sous [LLVM Release License](https://releases.llvm.org/2.8/LICENSE.TXT) pour le compilateur clang et le linker/debugger LLD
- [lcov](https://wiki.documentfoundation.org/Development/Lcov) version 1.14.1 sous [GNU General Public License v2.0](https://github.com/linux-test-project/lcov/blob/master/COPYING) pour la couverture de code 
- [doxygen](https://www.doxygen.nl) version 1.8.18 sous [GNU General Public License v2.0](https://www.doxygen.nl/index.html) pour la documentation générée (HTML, LaTex ou man)
- [graphViz](https://graphviz.org) version 2.42.1 sous [Eclipse Public License 1.0](https://www.eclipse.org/legal/epl-v10.html) pour les diagrammes UML générée pour la documentation doxygen (diagramme de dépendance, diagramme de classe, diagramme d'appel)
- [boost library](https://www.boost.org) version 1.73.0 sous [Boost Sofware License](https://www.boost.org/LICENSE_1_0.txt) pour les tests unitaires et les fonctionnalités serveurs (serveur HTTP, JSON lecture/écrite ou WebSocket)

> Voir le [rapport de couverture du projet](./report/coverage/index.html)

