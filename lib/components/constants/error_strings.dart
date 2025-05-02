class ErrorMsg {
  ErrorMsg._();

  static const String txtNoInternet = "No Internet Connection";
  static const String txtPleaseCheck =
      "Please check your internet connection and try again.";
  static const String txtError = "Error";

  /// Dio Exception Type
  static const String cancelMessage = "Request to API server was cancelled";
  static const String timeoutMessage = "Connection timeout with API server";
  static const String receiveTimeoutMessage =
      "Receive timeout in connection with API server";
  static const String unknownMessage =
      "Connection to server failed, Please check your internet connection";
  static const String sendTimeoutMessage =
      "Send timeout in connection with API server";

  /// Status Code
  static const String statusCode401 = "Unauthorized";
  static const String statusCode500 = "Internal server error";
  static const String statusCodeDefault = "Oops something went wrong";
}
