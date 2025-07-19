import 'dart:async';

/// JSON-RPC 2.0 notification received from server
class JsonRpcNotification {
  final String method;
  final Map<String, dynamic>? params;

  const JsonRpcNotification({required this.method, this.params});

  factory JsonRpcNotification.fromJson(Map<String, dynamic> json) {
    return JsonRpcNotification(
      method: json['method'] as String,
      params: json['params'] as Map<String, dynamic>?,
    );
  }
}

/// JSON-RPC 2.0 error
class JsonRpcError implements Exception {
  final int code;
  final String message;
  final dynamic data;

  const JsonRpcError({required this.code, required this.message, this.data});

  factory JsonRpcError.fromJson(Map<String, dynamic> json) {
    return JsonRpcError(
      code: json['code'] as int,
      message: json['message'] as String,
      data: json['data'],
    );
  }

  @override
  String toString() => 'JsonRpcError($code): $message';
}

/// JSON-RPC 2.0 client interface for making method calls
abstract class IJsonRpcClient {
  /// Make a JSON-RPC method call
  Future<T> call<T>(String method, [Map<String, dynamic>? params]);

  /// Stream of notifications from the server
  Stream<JsonRpcNotification> get notifications;

  /// Whether the client is connected and ready to make calls
  bool get isReady;

  /// Close the client and clean up resources
  Future<void> close();
}
