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
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() async {
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
      routerConfig: sl.get<MyRouter>().config(),
    );
  }
}
