import 'package:auto_route/auto_route.dart';
import 'package:koobits_flutter_app/presentation/screen/home/home_page.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class MyRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          initial: true,
          page: MyHomeRoute.page,
        ),
      ];
}
