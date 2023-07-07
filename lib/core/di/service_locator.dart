import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:koobits_flutter_app/core/api/post/i_post_provider.dart';
import 'package:koobits_flutter_app/core/api/post/post_provider.dart';
import 'package:koobits_flutter_app/core/common/network/dioclient/dio_network_client.dart';
import 'package:koobits_flutter_app/core/common/network/i_network_client.dart';
import 'package:koobits_flutter_app/core/common/network/options.dart';
import 'package:koobits_flutter_app/core/common/utils/blocutils/base_bloc_observer.dart';
import 'package:koobits_flutter_app/core/common/utils/logger/base_logger.dart';
import 'package:koobits_flutter_app/core/common/utils/logger/i_logger.dart';
import 'package:koobits_flutter_app/core/repository/postdata/i_post_repository.dart';
import 'package:koobits_flutter_app/core/repository/postdata/post_repository.dart';
import 'package:koobits_flutter_app/core/router/router.dart';
import 'package:koobits_flutter_app/presentation/bloc/post/post_cubit.dart';
import 'package:logger/logger.dart';

var sl = GetIt.instance;

Future<void> configureServiceLocator() async {
  sl.registerSingleton<MyRouter>(MyRouter());

  sl.registerSingleton<ILogger>(
      BaseLogger(
        Logger(
          level: Level.debug,
          printer: PrefixPrinter(
            PrettyPrinter(
              methodCount: 2,
              // number of method calls to be displayed
              errorMethodCount: 8,
              // number of method calls if stacktrace is provided
              lineLength: 90,
              // width of the output
              colors: true,
              // Colorful log messages
              printEmojis: true,
              // Print an emoji for each log message
              printTime: false,
            ),
          ),
        ),
      ),
      signalsReady: true);

  sl.registerSingleton<BlocObserver>(BaseAppBlocObserver(sl.get<ILogger>()));

  sl.registerSingleton<INetworkClient>(DioNetworkClient(
      BaseNetworkOptions(baseUrl: 'https://jsonplaceholder.typicode.com/')));

  sl.registerSingleton<IPostProvider>(PostProvider(sl.get<INetworkClient>()));

  sl.registerSingleton<IPostRepository>(
      PostRepository(sl.get<IPostProvider>()));

  sl.registerFactory<PostCubit>(() => PostCubit(sl.get<IPostRepository>()));
}
