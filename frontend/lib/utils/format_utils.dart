class FormatUtils {
  static String formatBytes(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    var i = 0;
    double num = bytes.toDouble();
    while (num >= 1024 && i < suffixes.length - 1) {
      num /= 1024;
      i++;
    }
    return '${num.toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  static String formatPercentage(double value, {int decimals = 1}) {
    return '${value.toStringAsFixed(decimals)}%';
  }

  static String formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final parts = <String>[];
    if (days > 0) parts.add('${days}d');
    if (hours > 0) parts.add('${hours}h');
    if (minutes > 0) parts.add('${minutes}m');
    if (seconds > 0 || parts.isEmpty) parts.add('${seconds}s');

    return parts.join(' ');
  }

  static String formatUptime(String uptimeString) {
    // Parse TrueNAS uptime format: "1 day, 2:30:45"
    try {
      final parts = uptimeString.split(', ');
      if (parts.length == 2) {
        final daysPart = parts[0];
        final timePart = parts[1];

        final days = int.tryParse(daysPart.split(' ')[0]) ?? 0;
        final timeParts = timePart.split(':');
        final hours = int.tryParse(timeParts[0]) ?? 0;
        final minutes = int.tryParse(timeParts[1]) ?? 0;

        final totalHours = days * 24 + hours;

        if (days > 0) {
          return '$days day${days != 1 ? 's' : ''}, $hours hour${hours != 1 ? 's' : ''}';
        } else if (totalHours > 0) {
          return '$totalHours hour${totalHours != 1 ? 's' : ''}, $minutes minute${minutes != 1 ? 's' : ''}';
        } else {
          return '$minutes minute${minutes != 1 ? 's' : ''}';
        }
      }
      return uptimeString;
    } catch (e) {
      return uptimeString;
    }
  }

  static String formatTemperature(double celsius, {int decimals = 1}) {
    return '${celsius.toStringAsFixed(decimals)}°C';
  }

  static String formatRPM(int rpm) {
    return '$rpm RPM';
  }
}
