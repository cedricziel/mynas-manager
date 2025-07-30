import '../models.dart';
import '../truenas_exceptions.dart';
import '../interfaces/connection_api.dart';
import '../interfaces/share_api.dart';

/// Share API mixin
mixin ShareApiMixin on IConnectionApi implements IShareApi {
  @override
  Future<List<Share>> listShares({ShareType? type}) async {
    final shares = <Share>[];

    if (type == null || type == ShareType.smb) {
      final smbShares = await call<List<dynamic>>('sharing.smb.query');
      shares.addAll(
        smbShares.map((share) {
          final shareMap = share as Map<String, dynamic>;
          return Share(
            id: shareMap['id']?.toString() ?? '',
            type: ShareType.smb,
            name: (shareMap['name'] as String?) ?? '',
            path: (shareMap['path'] as String?) ?? '',
            enabled: (shareMap['enabled'] as bool?) ?? false,
            comment: shareMap['comment'] as String?,
          );
        }),
      );
    }

    if (type == null || type == ShareType.nfs) {
      final nfsShares = await call<List<dynamic>>('sharing.nfs.query');
      shares.addAll(
        nfsShares.map((share) {
          final shareMap = share as Map<String, dynamic>;
          return Share(
            id: shareMap['id']?.toString() ?? '',
            type: ShareType.nfs,
            name: 'NFS: ${shareMap['path']}',
            path: (shareMap['path'] as String?) ?? '',
            enabled: (shareMap['enabled'] as bool?) ?? false,
            comment: shareMap['comment'] as String?,
          );
        }),
      );
    }

    return shares;
  }

  @override
  Future<Share> getShare(String id) async {
    // Try SMB first
    try {
      final shares = await call<List<dynamic>>('sharing.smb.query', [
        [
          ['id', '=', int.tryParse(id) ?? id],
        ],
      ]);

      if (shares.isNotEmpty) {
        final shareMap = shares.first as Map<String, dynamic>;
        return Share(
          id: shareMap['id']?.toString() ?? '',
          type: ShareType.smb,
          name: (shareMap['name'] as String?) ?? '',
          path: (shareMap['path'] as String?) ?? '',
          enabled: (shareMap['enabled'] as bool?) ?? false,
          comment: shareMap['comment'] as String?,
        );
      }
    } catch (_) {}

    // Try NFS
    final shares = await call<List<dynamic>>('sharing.nfs.query', [
      [
        ['id', '=', int.tryParse(id) ?? id],
      ],
    ]);

    if (shares.isEmpty) {
      throw TrueNasNotFoundException('Share not found: $id');
    }

    final shareMap = shares.first as Map<String, dynamic>;
    return Share(
      id: shareMap['id']?.toString() ?? '',
      type: ShareType.nfs,
      name: 'NFS: ${shareMap['path']}',
      path: (shareMap['path'] as String?) ?? '',
      enabled: (shareMap['enabled'] as bool?) ?? false,
      comment: shareMap['comment'] as String?,
    );
  }

  @override
  Future<Share> createShare(Share share) async {
    final method = share.type == ShareType.smb
        ? 'sharing.smb.create'
        : 'sharing.nfs.create';

    final data = await call<Map<String, dynamic>>(method, {
      'name': share.name,
      'path': share.path,
      'enabled': share.enabled,
      'comment': share.comment,
    });

    return share.copyWith(id: data['id']?.toString() ?? '');
  }

  @override
  Future<Share> updateShare(Share share) async {
    final method = share.type == ShareType.smb
        ? 'sharing.smb.update'
        : 'sharing.nfs.update';

    await call<dynamic>(method, [
      int.tryParse(share.id) ?? share.id,
      {
        'name': share.name,
        'path': share.path,
        'enabled': share.enabled,
        'comment': share.comment,
      },
    ]);

    return share;
  }

  @override
  Future<bool> deleteShare(String id) async {
    // Try SMB first
    try {
      await call<dynamic>('sharing.smb.delete', [int.tryParse(id) ?? id]);
      return true;
    } catch (_) {}

    // Try NFS
    await call<dynamic>('sharing.nfs.delete', [int.tryParse(id) ?? id]);
    return true;
  }
}
