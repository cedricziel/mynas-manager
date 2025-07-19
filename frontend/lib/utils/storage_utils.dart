import 'dart:math';

class StorageUtils {
  /// Format bytes into human-readable format (e.g., "1.5 GB", "256 MB")
  static String formatBytes(int bytes, {int decimals = 1}) {
    if (bytes <= 0) return "0 B";

    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    final i = (log(bytes) / log(1024)).floor();
    final value = bytes / pow(1024, i);

    return "${value.toStringAsFixed(decimals)} ${suffixes[i]}";
  }

  /// Format bytes into human-readable format with binary units (e.g., "1.5 GiB", "256 MiB")
  static String formatBytesBI(int bytes, {int decimals = 1}) {
    if (bytes <= 0) return "0 B";

    const suffixes = [
      "B",
      "KiB",
      "MiB",
      "GiB",
      "TiB",
      "PiB",
      "EiB",
      "ZiB",
      "YiB",
    ];
    final i = (log(bytes) / log(1024)).floor();
    final value = bytes / pow(1024, i);

    return "${value.toStringAsFixed(decimals)} ${suffixes[i]}";
  }

  /// Calculate percentage with safe division
  static double calculatePercentage(int used, int total) {
    if (total <= 0) return 0.0;
    return (used / total) * 100;
  }

  /// Format a relative time (e.g., "2 minutes ago", "1 hour ago")
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes minute${minutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours hour${hours == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 30) {
      final days = difference.inDays;
      return '$days day${days == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    }
  }

  /// Format duration in a human-readable way
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  /// Get color for storage usage percentage
  static String getUsageColorHex(double percentage) {
    if (percentage >= 90) {
      return '#F44336'; // Red
    } else if (percentage >= 75) {
      return '#FF9800'; // Orange
    } else if (percentage >= 50) {
      return '#FFC107'; // Amber
    } else {
      return '#4CAF50'; // Green
    }
  }

  /// Get pool health icon based on status
  static String getPoolHealthIcon(bool isHealthy, String status) {
    if (!isHealthy) {
      switch (status.toLowerCase()) {
        case 'degraded':
          return 'warning';
        case 'faulted':
        case 'unavail':
          return 'error';
        default:
          return 'warning_amber';
      }
    }
    return 'check_circle';
  }

  /// Get pool status color
  static String getPoolStatusColor(bool isHealthy, String status) {
    if (!isHealthy) {
      switch (status.toLowerCase()) {
        case 'degraded':
          return '#FF9800'; // Orange
        case 'faulted':
        case 'unavail':
          return '#F44336'; // Red
        default:
          return '#FF5722'; // Deep Orange
      }
    }
    return '#4CAF50'; // Green
  }

  /// Format throughput (bytes per second)
  static String formatThroughput(int bytesPerSecond) {
    if (bytesPerSecond <= 0) return "0 B/s";

    const suffixes = ["B/s", "KB/s", "MB/s", "GB/s", "TB/s"];
    final i = (log(bytesPerSecond) / log(1024)).floor();
    final value = bytesPerSecond / pow(1024, i);

    return "${value.toStringAsFixed(1)} ${suffixes[i]}";
  }

  /// Format IOPS (Input/Output Operations Per Second)
  static String formatIOPS(int iops) {
    if (iops < 1000) {
      return '$iops IOPS';
    } else if (iops < 1000000) {
      return '${(iops / 1000).toStringAsFixed(1)}K IOPS';
    } else {
      return '${(iops / 1000000).toStringAsFixed(1)}M IOPS';
    }
  }

  /// Get scrub status color
  static String getScrubStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'running':
      case 'scanning':
        return '#2196F3'; // Blue
      case 'finished':
      case 'completed':
        return '#4CAF50'; // Green
      case 'canceled':
      case 'cancelled':
        return '#FF9800'; // Orange
      case 'error':
        return '#F44336'; // Red
      default:
        return '#9E9E9E'; // Grey
    }
  }

  /// Get resilver status color
  static String getResilverStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'running':
      case 'resilvering':
        return '#2196F3'; // Blue
      case 'finished':
      case 'completed':
        return '#4CAF50'; // Green
      case 'canceled':
      case 'cancelled':
        return '#FF9800'; // Orange
      case 'error':
        return '#F44336'; // Red
      default:
        return '#9E9E9E'; // Grey
    }
  }

  /// Format a cron expression into human-readable text
  static String formatCronExpression(String cronExpression) {
    // Basic cron parsing - can be enhanced with a proper cron library
    final parts = cronExpression.split(' ');
    if (parts.length != 5) return cronExpression;

    final minute = parts[0];
    final hour = parts[1];
    final day = parts[2];
    final month = parts[3];
    final weekday = parts[4];

    // Handle some common patterns
    if (minute == '0' &&
        hour == '0' &&
        day == '*' &&
        month == '*' &&
        weekday == '0') {
      return 'Weekly on Sunday at midnight';
    } else if (minute == '0' &&
        hour == '2' &&
        day == '*' &&
        month == '*' &&
        weekday == '*') {
      return 'Daily at 2:00 AM';
    } else if (minute == '0' &&
        hour == '0' &&
        day == '1' &&
        month == '*' &&
        weekday == '*') {
      return 'Monthly on the 1st at midnight';
    }

    return cronExpression; // Fallback to raw expression
  }

  /// Calculate estimated completion time based on progress
  static DateTime? estimateCompletion(
    DateTime startTime,
    double progressPercentage,
  ) {
    if (progressPercentage <= 0 || progressPercentage >= 100) {
      return null;
    }

    final elapsed = DateTime.now().difference(startTime);
    final totalEstimated = elapsed.inMilliseconds / (progressPercentage / 100);
    final remaining = totalEstimated - elapsed.inMilliseconds;

    return DateTime.now().add(Duration(milliseconds: remaining.round()));
  }

  /// Format ZFS pool topology type
  static String formatVdevType(String type) {
    switch (type.toLowerCase()) {
      case 'mirror':
        return 'Mirror';
      case 'raidz1':
        return 'RAID-Z1';
      case 'raidz2':
        return 'RAID-Z2';
      case 'raidz3':
        return 'RAID-Z3';
      case 'stripe':
        return 'Stripe';
      case 'log':
        return 'Log Device';
      case 'cache':
        return 'Cache Device';
      case 'spare':
        return 'Hot Spare';
      default:
        return type.toUpperCase();
    }
  }
}
