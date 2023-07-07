#!/bin/sh

# This script is to calculate coverage for unit tests on repository and bloc layer

removeExtra () {
  lcov --remove coverage/lcov.info \
'lib/main.dart' \
'lib/core/api/*' \
'lib/core/common/*' \
'lib/core/coordinator/*' \
'lib/core/di/*' \
'lib/core/model/*' \
'lib/core/router/*' \
'lib/presentation/widget/*' \
'lib/presentation/*/*_state.dart' \
-o coverage/lcov.info
}

flutter test --coverage
removeExtra
genhtml coverage/lcov.info -o coverage/html