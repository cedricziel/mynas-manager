// Mocks generated by Mockito 5.4.6 from annotations
// in mynas_backend/test/services/truenas_heartbeat_service_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i2;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;
import 'package:truenas_client/src/models.dart' as _i6;
import 'package:truenas_client/src/models/connection_status.dart' as _i5;
import 'package:truenas_client/src/truenas_client_interface.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeFuture_0<T1> extends _i1.SmartFake implements _i2.Future<T1> {
  _FakeFuture_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [ITrueNasClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockITrueNasClient extends _i1.Mock implements _i3.ITrueNasClient {
  MockITrueNasClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Future<void> connect() =>
      (super.noSuchMethod(
            Invocation.method(#connect, []),
            returnValue: _i2.Future<void>.value(),
            returnValueForMissingStub: _i2.Future<void>.value(),
          )
          as _i2.Future<void>);

  @override
  _i2.Future<void> disconnect() =>
      (super.noSuchMethod(
            Invocation.method(#disconnect, []),
            returnValue: _i2.Future<void>.value(),
            returnValueForMissingStub: _i2.Future<void>.value(),
          )
          as _i2.Future<void>);

  @override
  _i2.Future<T> call<T>(String? method, [List<dynamic>? params = const []]) =>
      (super.noSuchMethod(
            Invocation.method(#call, [method, params]),
            returnValue:
                _i4.ifNotNull(
                  _i4.dummyValueOrNull<T>(
                    this,
                    Invocation.method(#call, [method, params]),
                  ),
                  (T v) => _i2.Future<T>.value(v),
                ) ??
                _FakeFuture_0<T>(
                  this,
                  Invocation.method(#call, [method, params]),
                ),
          )
          as _i2.Future<T>);

  @override
  _i2.Stream<_i5.ConnectionStatus> heartbeat({
    Duration? interval = const Duration(seconds: 10),
  }) =>
      (super.noSuchMethod(
            Invocation.method(#heartbeat, [], {#interval: interval}),
            returnValue: _i2.Stream<_i5.ConnectionStatus>.empty(),
          )
          as _i2.Stream<_i5.ConnectionStatus>);

  @override
  _i2.Future<void> stopHeartbeat() =>
      (super.noSuchMethod(
            Invocation.method(#stopHeartbeat, []),
            returnValue: _i2.Future<void>.value(),
            returnValueForMissingStub: _i2.Future<void>.value(),
          )
          as _i2.Future<void>);

  @override
  _i2.Future<_i6.SystemInfo> getSystemInfo() =>
      (super.noSuchMethod(
            Invocation.method(#getSystemInfo, []),
            returnValue: _i2.Future<_i6.SystemInfo>.value(
              _i4.dummyValue<_i6.SystemInfo>(
                this,
                Invocation.method(#getSystemInfo, []),
              ),
            ),
          )
          as _i2.Future<_i6.SystemInfo>);

  @override
  _i2.Future<List<_i6.Alert>> getAlerts() =>
      (super.noSuchMethod(
            Invocation.method(#getAlerts, []),
            returnValue: _i2.Future<List<_i6.Alert>>.value(<_i6.Alert>[]),
          )
          as _i2.Future<List<_i6.Alert>>);

  @override
  _i2.Future<List<_i6.Pool>> listPools() =>
      (super.noSuchMethod(
            Invocation.method(#listPools, []),
            returnValue: _i2.Future<List<_i6.Pool>>.value(<_i6.Pool>[]),
          )
          as _i2.Future<List<_i6.Pool>>);

  @override
  _i2.Future<_i6.Pool> getPool(String? id) =>
      (super.noSuchMethod(
            Invocation.method(#getPool, [id]),
            returnValue: _i2.Future<_i6.Pool>.value(
              _i4.dummyValue<_i6.Pool>(this, Invocation.method(#getPool, [id])),
            ),
          )
          as _i2.Future<_i6.Pool>);

  @override
  _i2.Future<List<_i6.Dataset>> listDatasets({String? poolId}) =>
      (super.noSuchMethod(
            Invocation.method(#listDatasets, [], {#poolId: poolId}),
            returnValue: _i2.Future<List<_i6.Dataset>>.value(<_i6.Dataset>[]),
          )
          as _i2.Future<List<_i6.Dataset>>);

  @override
  _i2.Future<_i6.Dataset> getDataset(String? id) =>
      (super.noSuchMethod(
            Invocation.method(#getDataset, [id]),
            returnValue: _i2.Future<_i6.Dataset>.value(
              _i4.dummyValue<_i6.Dataset>(
                this,
                Invocation.method(#getDataset, [id]),
              ),
            ),
          )
          as _i2.Future<_i6.Dataset>);

  @override
  _i2.Future<_i6.Dataset> createDataset({
    required String? pool,
    required String? name,
    Map<String, dynamic>? properties,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#createDataset, [], {
              #pool: pool,
              #name: name,
              #properties: properties,
            }),
            returnValue: _i2.Future<_i6.Dataset>.value(
              _i4.dummyValue<_i6.Dataset>(
                this,
                Invocation.method(#createDataset, [], {
                  #pool: pool,
                  #name: name,
                  #properties: properties,
                }),
              ),
            ),
          )
          as _i2.Future<_i6.Dataset>);

  @override
  _i2.Future<_i6.Dataset> updateDataset(
    String? id,
    Map<String, dynamic>? properties,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#updateDataset, [id, properties]),
            returnValue: _i2.Future<_i6.Dataset>.value(
              _i4.dummyValue<_i6.Dataset>(
                this,
                Invocation.method(#updateDataset, [id, properties]),
              ),
            ),
          )
          as _i2.Future<_i6.Dataset>);

  @override
  _i2.Future<bool> deleteDataset(String? id, {bool? recursive = false}) =>
      (super.noSuchMethod(
            Invocation.method(#deleteDataset, [id], {#recursive: recursive}),
            returnValue: _i2.Future<bool>.value(false),
          )
          as _i2.Future<bool>);

  @override
  _i2.Future<List<_i6.Share>> listShares({_i6.ShareType? type}) =>
      (super.noSuchMethod(
            Invocation.method(#listShares, [], {#type: type}),
            returnValue: _i2.Future<List<_i6.Share>>.value(<_i6.Share>[]),
          )
          as _i2.Future<List<_i6.Share>>);

  @override
  _i2.Future<_i6.Share> getShare(String? id) =>
      (super.noSuchMethod(
            Invocation.method(#getShare, [id]),
            returnValue: _i2.Future<_i6.Share>.value(
              _i4.dummyValue<_i6.Share>(
                this,
                Invocation.method(#getShare, [id]),
              ),
            ),
          )
          as _i2.Future<_i6.Share>);

  @override
  _i2.Future<_i6.Share> createShare(_i6.Share? share) =>
      (super.noSuchMethod(
            Invocation.method(#createShare, [share]),
            returnValue: _i2.Future<_i6.Share>.value(
              _i4.dummyValue<_i6.Share>(
                this,
                Invocation.method(#createShare, [share]),
              ),
            ),
          )
          as _i2.Future<_i6.Share>);

  @override
  _i2.Future<_i6.Share> updateShare(_i6.Share? share) =>
      (super.noSuchMethod(
            Invocation.method(#updateShare, [share]),
            returnValue: _i2.Future<_i6.Share>.value(
              _i4.dummyValue<_i6.Share>(
                this,
                Invocation.method(#updateShare, [share]),
              ),
            ),
          )
          as _i2.Future<_i6.Share>);

  @override
  _i2.Future<bool> deleteShare(String? id) =>
      (super.noSuchMethod(
            Invocation.method(#deleteShare, [id]),
            returnValue: _i2.Future<bool>.value(false),
          )
          as _i2.Future<bool>);

  @override
  _i2.Future<List<_i6.Disk>> listDisks() =>
      (super.noSuchMethod(
            Invocation.method(#listDisks, []),
            returnValue: _i2.Future<List<_i6.Disk>>.value(<_i6.Disk>[]),
          )
          as _i2.Future<List<_i6.Disk>>);

  @override
  _i2.Future<_i6.Disk> getDisk(String? identifier) =>
      (super.noSuchMethod(
            Invocation.method(#getDisk, [identifier]),
            returnValue: _i2.Future<_i6.Disk>.value(
              _i4.dummyValue<_i6.Disk>(
                this,
                Invocation.method(#getDisk, [identifier]),
              ),
            ),
          )
          as _i2.Future<_i6.Disk>);
}
