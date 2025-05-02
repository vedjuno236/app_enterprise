import 'package:dio/dio.dart';
import 'package:enterprise/components/constants/error_strings.dart';
import 'package:get/get.dart';

class DioExceptions implements Exception {
  DioExceptions.fromDioError(DioException dioError) {
    // logger.e("dioError${dioError.type}");
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = ErrorMsg.cancelMessage.tr;
        break;
      case DioExceptionType.connectionTimeout:
        message = ErrorMsg.timeoutMessage.tr;
        break;
      case DioExceptionType.unknown:
        message = ErrorMsg.unknownMessage.tr;
        break;
      case DioExceptionType.receiveTimeout:
        message = ErrorMsg.receiveTimeoutMessage.tr;
        break;

      case DioExceptionType.badResponse:
        message = _handleError(
            dioError.response?.statusCode ?? 500, dioError.response?.data);
        break;
      case DioExceptionType.sendTimeout:
        message = ErrorMsg.sendTimeoutMessage.tr;
        break;
      default:
        message = ErrorMsg.unknownMessage.tr;
        break;
    }
  }

  late String message;
  late int status;

  String _handleError(int statusCode, dynamic errorData) {
    if (errorData == null) return ErrorMsg.statusCodeDefault.tr;
    try {
      String errorMessage =
          errorData is Map<String, dynamic> && errorData.containsKey('error')
              ? errorData['error'].toString()
              : ErrorMsg.statusCodeDefault.tr;
      //
      switch (statusCode) {
        case 400:
          return errorMessage.tr;
        case 401:
          return ErrorMsg.statusCode401.tr;
        case 404:
          return errorMessage.tr;
        case 500:
          return ErrorMsg.statusCode500.tr;
        case 422:
          return errorMessage.tr;

        default:
          return ErrorMsg.statusCodeDefault.tr;
      }
    } catch (e) {
      return ErrorMsg.unknownMessage.tr;
    }
  }

  @override
  String toString() => message;
}
