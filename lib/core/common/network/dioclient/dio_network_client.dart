import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:koobits_flutter_app/core/common/error/exception.dart';
import 'package:koobits_flutter_app/core/common/network/http_response.dart';
import 'package:koobits_flutter_app/core/common/network/i_network_client.dart';
import 'package:koobits_flutter_app/core/common/network/options.dart';

class DioNetworkClient implements INetworkClient {
  late Dio _dio;
  final Duration connectionTimeout = const Duration(
      seconds: 30); //30 seconds, default is never timeout

  DioNetworkClient(BaseNetworkOptions networkOptions) {
    var options = BaseOptions(
      baseUrl: networkOptions.baseUrl,
      headers: networkOptions.headers,
      connectTimeout: connectionTimeout,
      receiveTimeout: connectionTimeout,
    );
    _dio = Dio(options);
  }

  @override
  Future<HttpResponse<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters,
        NetworkOptions? options,
        CacheOptions? cacheOptions}) {
    Options? buildCache;
    buildCache = _createOptions(options);

    if (cacheOptions != null) {
      buildCache = buildCache.copyWith(extra: cacheOptions.toExtra());
    }

    return _dio
        .get<T>(path, queryParameters: queryParameters, options: buildCache)
        .then((Response<T> res) {
      _throwIfNoSuccess(res);
      var response = HttpResponse<T>(
          data: res.data,
          headers: res.headers.map,
          statusCode: res.statusCode ?? 0,
          statusMessage: res.statusMessage ?? '');
      return response;
    });
  }


  @override
  Future<HttpResponse<T>> post<T>(String path,
      {dynamic data,
        Map<String, dynamic>? queryParameters,
        String? contentType,
        NetworkOptions? options,
        CacheOptions? cacheOptions}) {
    Options? buildCache;
    buildCache = _createOptions(options);

    if (cacheOptions != null) {
      buildCache = buildCache.copyWith(extra: cacheOptions.toExtra());
    }

    return _dio
        .post<T>(path,
        data: data, queryParameters: queryParameters, options: buildCache)
        .then((Response<T> res) {
      _throwIfNoSuccess(res);
      var response = HttpResponse<T>(
          data: res.data,
          headers: res.headers.map,
          statusCode: res.statusCode,
          statusMessage: res.statusMessage);
      return response;
    });
  }

  Options _createOptions(NetworkOptions? networkOptions) {
    return Options(
        method: networkOptions?.method,
        headers: networkOptions?.headers,
        contentType: networkOptions?.contentType,
        sendTimeout: networkOptions?.sendTimeout,
        receiveTimeout: networkOptions?.receiveTimeout,
        extra: networkOptions?.extra);
  }

  void _throwIfNoSuccess(Response res) {
    if (res.data == null) {
      throw HttpException.serverException(res.statusMessage ?? '', res);
    }

    if (res.statusCode != null &&
        (res.statusCode! < 200 || res.statusCode! > 299) &&
        res.statusCode != 304) {
      var response = HttpResponse<dynamic>(
          data: res.data,
          headers: res.headers.map,
          statusCode: res.statusCode,
          statusMessage: res.statusMessage);
      throw HttpException.serverException(res.statusMessage ?? '', response);
    }
  }
}
