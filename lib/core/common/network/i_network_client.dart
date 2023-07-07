import 'package:koobits_flutter_app/core/common/network/http_response.dart';
import 'package:koobits_flutter_app/core/common/network/options.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

abstract class INetworkClient {
  Future<HttpResponse<T>> get<T>(String path,
      {Map<String, dynamic> queryParameters,
      NetworkOptions? options,
      CacheOptions? cacheOptions});

  Future<HttpResponse<T>> post<T>(String path,
      {dynamic data,
      Map<String, dynamic> queryParameters,
      NetworkOptions? options,
      CacheOptions? cacheOptions});
}
