# koobits_flutter_app

A new Flutter project.

## Getting Started

Flutter version: 3.10.5
Dart version : 3.0.5

Before running the app for the first time please to run the following commands

- flutter pub get
- dart run build_runner build --delete-conflicting-outputs

Once the above steps are completed, you may begin the build for either your Android or iOS simulators

## Testing

NOTE: Please have lcov (via brew usually) installed if using the script

Please run the `run_test_with_coverage.sh` script to automate the testing and creation of coverage html
Proceed to dir coverage/html/index.html and open in browser to check coverage status.

Notes:

1) At present , unit test coverage for bloc and repo layers are 100%, whilst widget testing needs further work
2) Retry mechanism for API needs to be added to move out of error state to success
3) Logic for search can also be improved by using FuzzyWuzzy package



