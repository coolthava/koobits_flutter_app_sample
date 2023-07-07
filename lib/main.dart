import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koobits_flutter_app/core/di/service_locator.dart';
import 'package:koobits_flutter_app/core/router/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AutoRouterDelegate? _routerDelegate;

  @override
  void didChangeDependencies() async {
    _routerDelegate = AutoRouterDelegate(
      sl.get<MyRouter>(),
    );

    Bloc.observer = sl.get<BlocObserver>();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Koobits Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerDelegate: _routerDelegate!,
      routeInformationParser: sl.get<MyRouter>().defaultRouteParser(),
      routeInformationProvider: sl.get<MyRouter>().routeInfoProvider(),
    );
  }
}
