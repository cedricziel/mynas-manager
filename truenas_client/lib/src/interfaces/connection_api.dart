/// Connection API interface
abstract class IConnectionApi {
  /// Connect to TrueNAS
  Future<void> connect();

  /// Disconnect from TrueNAS
  Future<void> disconnect();

  /// Make a raw JSON-RPC call
  /// [params] must be a List as per JSON-RPC 2.0 specification
  Future<T> call<T>(String method, [List<dynamic> params = const []]);
}
