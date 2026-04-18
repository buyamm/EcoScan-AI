import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/ai_analysis_model.dart';
import '../../data/models/product_model.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

class AIExplanationScreen extends StatelessWidget {
  final ProductModel? product;
  final AIAnalysisModel analysis;

  const AIExplanationScreen({
    super.key,
    this.product,
    required this.analysis,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phân tích AI đầy đủ')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Overall
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.summarize_outlined,
                          color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      const Text('Tóm tắt',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      EcoScoreChip(
                          level: analysis.level,
                          score: analysis.overallScore,
                          showScore: true),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    analysis.summary.isNotEmpty
                        ? analysis.summary
                        : 'Không có tóm tắt.',
                    style: TextStyle(
                        fontSize: 14, color: Colors.grey[700], height: 1.6),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Health section
          _AnalysisSection(
            icon: Icons.favorite_outline,
            title: 'Sức khỏe',
            score: analysis.health.score,
            concerns: analysis.health.concerns,
            positives: analysis.health.positives,
            onDetailTap: () => context.push('/product/health', extra: {
              'product': product,
              'analysis': analysis,
            }),
          ),
          const SizedBox(height: 8),
          // Environment section
          _AnalysisSection(
            icon: Icons.eco_outlined,
            title: 'Môi trường',
            score: analysis.environment.score,
            concerns: analysis.environment.concerns,
            positives: analysis.environment.positives,
            onDetailTap: () => context.push('/product/environment', extra: {
              'product': product,
              'analysis': analysis,
            }),
          ),
          const SizedBox(height: 8),
          // Ethics section
          _EthicsSection(
            ethics: analysis.ethics,
            onDetailTap: () => context.push('/product/ethics', extra: {
              'product': product,
              'analysis': analysis,
            }),
          ),
          const SizedBox(height: 8),
          // Greenwashing section
          _GreenwashingSection(result: analysis.greenwashing),
          const SizedBox(height: 8),
          // Suitable for
          if (analysis.suitableFor.isNotEmpty ||
              analysis.notSuitableFor.isNotEmpty)
            _AudienceSection(analysis: analysis),
          const SizedBox(height: 8),
          // Ingredient count
          if (analysis.ingredients.isNotEmpty)
            Card(
              child: ListTile(
                leading:
                    const Icon(Icons.list_alt, color: AppColors.primary),
                title: Text(
                    '${analysis.ingredients.length} thành phần được phân tích'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/product/ingredients', extra: {
                  'product': product,
                  'analysis': analysis,
                }),
              ),
            ),
          // Raw text fallback
          if (analysis.rawText != null) ...[
            const SizedBox(height: 8),
            _RawTextSection(rawText: analysis.rawText!),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _AnalysisSection extends StatefulWidget {
  final IconData icon;
  final String title;
  final int score;
  final List<String> concerns;
  final List<String> positives;
  final VoidCallback onDetailTap;

  const _AnalysisSection({
    required this.icon,
    required this.title,
    required this.score,
    required this.concerns,
    required this.positives,
    required this.onDetailTap,
  });

  @override
  State<_AnalysisSection> createState() => _AnalysisSectionState();
}

class _AnalysisSectionState extends State<_AnalysisSection> {
  bool _expanded = false;

  Color get _scoreColor {
    if (widget.score >= 70) return AppColors.primary;
    if (widget.score >= 40) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(widget.icon, color: _scoreColor, size: 20),
                  const SizedBox(width: 10),
                  Text(widget.title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _scoreColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${widget.score}/100',
                      style: TextStyle(
                        color: _scoreColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.positives.isNotEmpty) ...[
                    const Text('Điểm tốt',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary)),
                    const SizedBox(height: 6),
                    ...widget.positives.map((p) => _BulletItem(text: p, color: AppColors.primary)),
                    const SizedBox(height: 10),
                  ],
                  if (widget.concerns.isNotEmpty) ...[
                    const Text('Điểm lo ngại',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.danger)),
                    const SizedBox(height: 6),
                    ...widget.concerns.map((c) => _BulletItem(text: c, color: AppColors.danger)),
                    const SizedBox(height: 10),
                  ],
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: widget.onDetailTap,
                      child: const Text('Xem chi tiết →'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EthicsSection extends StatefulWidget {
  final EthicsAnalysis ethics;
  final VoidCallback onDetailTap;

  const _EthicsSection({required this.ethics, required this.onDetailTap});

  @override
  State<_EthicsSection> createState() => _EthicsSectionState();
}

class _EthicsSectionState extends State<_EthicsSection> {
  bool _expanded = false;

  Color get _scoreColor {
    if (widget.ethics.score >= 70) return AppColors.primary;
    if (widget.ethics.score >= 40) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.balance_outlined, color: _scoreColor, size: 20),
                  const SizedBox(width: 10),
                  const Text('Đạo đức',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _scoreColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${widget.ethics.score}/100',
                      style: TextStyle(
                        color: _scoreColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.ethics.crueltyFree != null)
                    _EthicsTag(
                      label: 'Cruelty-free',
                      value: widget.ethics.crueltyFree!,
                    ),
                  if (widget.ethics.vegan != null)
                    _EthicsTag(
                      label: 'Thuần chay (Vegan)',
                      value: widget.ethics.vegan!,
                    ),
                  if (widget.ethics.concerns.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Text('Lo ngại',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.danger)),
                    const SizedBox(height: 6),
                    ...widget.ethics.concerns
                        .map((c) => _BulletItem(text: c, color: AppColors.danger)),
                  ],
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: widget.onDetailTap,
                      child: const Text('Xem chi tiết →'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _GreenwashingSection extends StatelessWidget {
  final GreenwashingResult result;

  const _GreenwashingSection({required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.gpp_bad_outlined,
                    color: AppColors.warning, size: 20),
                const SizedBox(width: 8),
                const Text('Greenwashing',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
                const Spacer(),
                GreenwashingBadge(level: result.level, compact: true),
              ],
            ),
            if (result.claims.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...result.claims.take(2).map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• "${c.claim}"',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[700]),
                          ),
                          Text(
                            '  → ${c.reality}',
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.danger),
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AudienceSection extends StatelessWidget {
  final AIAnalysisModel analysis;

  const _AudienceSection({required this.analysis});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.people_outline, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Text('Đối tượng phù hợp',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ],
            ),
            if (analysis.suitableFor.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: analysis.suitableFor
                    .map((s) => _AudienceChip(label: s, suitable: true))
                    .toList(),
              ),
            ],
            if (analysis.notSuitableFor.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text('Không phù hợp:',
                  style: TextStyle(fontSize: 12, color: AppColors.danger)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: analysis.notSuitableFor
                    .map((s) => _AudienceChip(label: s, suitable: false))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RawTextSection extends StatelessWidget {
  final String rawText;

  const _RawTextSection({required this.rawText});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.text_snippet_outlined,
                    color: Colors.grey, size: 18),
                SizedBox(width: 8),
                Text('Phân tích thô',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              rawText,
              style: TextStyle(
                  fontSize: 12, color: Colors.grey[600], height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  final Color color;

  const _BulletItem({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: TextStyle(fontSize: 13, color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }
}

class _EthicsTag extends StatelessWidget {
  final String label;
  final bool value;

  const _EthicsTag({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final color = value ? AppColors.primary : AppColors.danger;
    final icon = value ? Icons.check_circle_outline : Icons.cancel_outlined;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 13, color: color)),
        ],
      ),
    );
  }
}

class _AudienceChip extends StatelessWidget {
  final String label;
  final bool suitable;

  const _AudienceChip({required this.label, required this.suitable});

  @override
  Widget build(BuildContext context) {
    final color = suitable ? AppColors.primary : AppColors.danger;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 12, color: color, fontWeight: FontWeight.w500)),
    );
  }
}
