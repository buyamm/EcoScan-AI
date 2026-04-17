import '../../data/models/ai_analysis_model.dart';
import '../../data/models/scan_record.dart';

/// Represents a single achievement milestone.
class AchievementMilestone {
  final String id;
  final String title;
  final String emoji;

  const AchievementMilestone({
    required this.id,
    required this.title,
    required this.emoji,
  });
}

/// Checks which achievement milestones are newly unlocked after a scan.
///
/// Call [checkNewAchievements] with the full history (including the new record)
/// and the previous total to get a list of newly unlocked [AchievementMilestone]s.
class AchievementService {
  AchievementService._();

  /// Returns a list of achievements that were just unlocked by the latest scan.
  ///
  /// [allRecords] should include the record that was just saved.
  /// [previousTotal] is the number of records *before* the latest save.
  static List<AchievementMilestone> checkNewAchievements({
    required List<ScanRecord> allRecords,
    required int previousTotal,
  }) {
    final total = allRecords.length;
    final greenCount = allRecords
        .where((r) => r.analysis.level == EcoScoreLevel.green)
        .length;
    final previousGreenCount = allRecords
        .take(previousTotal) // order is newest-first from repo, so take last N
        .where((r) => r.analysis.level == EcoScoreLevel.green)
        .length;

    final unlocked = <AchievementMilestone>[];

    // First scan
    if (previousTotal == 0 && total >= 1) {
      unlocked.add(const AchievementMilestone(
        id: 'first_scan',
        title: 'Lần quét đầu tiên',
        emoji: '🌱',
      ));
    }

    // 10 scans
    if (previousTotal < 10 && total >= 10) {
      unlocked.add(const AchievementMilestone(
        id: 'scan_10',
        title: 'Người khám phá — 10 lần quét',
        emoji: '🔍',
      ));
    }

    // 50 scans
    if (previousTotal < 50 && total >= 50) {
      unlocked.add(const AchievementMilestone(
        id: 'scan_50',
        title: 'Chuyên gia quét — 50 lần quét',
        emoji: '🏆',
      ));
    }

    // First green product
    if (previousGreenCount == 0 && greenCount >= 1) {
      unlocked.add(const AchievementMilestone(
        id: 'first_green',
        title: 'Sản phẩm xanh đầu tiên',
        emoji: '🟢',
      ));
    }

    // 5 green products
    if (previousGreenCount < 5 && greenCount >= 5) {
      unlocked.add(const AchievementMilestone(
        id: 'green_5',
        title: 'Người tiêu dùng xanh — 5 sản phẩm tốt',
        emoji: '🌿',
      ));
    }

    // 20 green products
    if (previousGreenCount < 20 && greenCount >= 20) {
      unlocked.add(const AchievementMilestone(
        id: 'green_20',
        title: 'Chiến binh eco — 20 sản phẩm tốt',
        emoji: '🌍',
      ));
    }

    return unlocked;
  }
}
