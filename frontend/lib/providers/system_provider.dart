import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_shared/mynas_shared.dart';
import 'package:mynas_frontend/services/rpc_client.dart';

final systemInfoNotifierProvider = AsyncNotifierProvider<SystemInfoNotifier, SystemInfo?>(
  SystemInfoNotifier.new,
);

class SystemInfoNotifier extends AsyncNotifier<SystemInfo?> {
  Timer? _timer;
  
  @override
  Future<SystemInfo?> build() async {
    // Initially connect to the backend
    final client = ref.watch(rpcClientProvider);
    
    if (!client.isConnected) {
      await client.connect();
    }
    
    // Start polling for system info
    ref.onDispose(() {
      _timer?.cancel();
    });
    _startPolling();
    
    return await _fetchSystemInfo();
  }

  void _startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (state.hasValue) {
        try {
          final newInfo = await _fetchSystemInfo();
          if (newInfo != null) {
            state = AsyncData(newInfo);
          }
        } catch (e) {
          // Log error but keep the last known state
        }
      }
    });
  }

  Future<SystemInfo?> _fetchSystemInfo() async {
    try {
      final client = ref.read(rpcClientProvider);
      final data = await client.getSystemInfo();
      return SystemInfo.fromJson(data);
    } catch (e) {
      // Return null on error
      return null;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final info = await _fetchSystemInfo();
    if (info != null) {
      state = AsyncData(info);
    } else {
      state = AsyncError('Failed to fetch system info', StackTrace.current);
    }
  }
}

final systemAlertsProvider = FutureProvider<List<Alert>>((ref) async {
  final client = ref.watch(rpcClientProvider);
  
  try {
    final data = await client.getAlerts();
    return data.map((json) => Alert.fromJson(json as Map<String, dynamic>)).toList();
  } catch (e) {
    return [];
  }
});