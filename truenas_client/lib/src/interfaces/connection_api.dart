/// Connection API interface
abstract class IConnectionApi {
  /// Connect to TrueNAS
  Future<void> connect();

  /// Disconnect from TrueNAS
  Future<void> disconnect();

  /// Make a raw JSON-RPC call
  Future<T> call<T>(String method, [dynamic params]);
}
