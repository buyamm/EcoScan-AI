import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/history/history_cubit.dart';

class ExportDataScreen extends StatefulWidget {
  const ExportDataScreen({super.key});

  @override
  State<ExportDataScreen> createState() => _ExportDataScreenState();
}

class _ExportDataScreenState extends State<ExportDataScreen> {
  bool _exporting = false;
  String _selectedFormat = 'json';

  Future<void> _export() async {
    setState(() => _exporting = true);
    try {
      final records =
          context.read<HistoryCubit>().state.allRecords;
      final String content;
      final String mimeType;
      final String fileName;

      if (_selectedFormat == 'json') {
        final list = records.map((r) => r.toJson()).toList();
        content = const JsonEncoder.withIndent('  ').convert(list);
        mimeType = 'application/json';
        fileName = 'ecoscan_history.json';
      } else {
        // CSV format
        final buffer = StringBuffer();
        buffer.writeln(
            'ID,Tên sản phẩm,Thương hiệu,Điểm,Mức,Phương thức,Ngày quét');
        for (final r in records) {
          buffer.writeln(
              '${r.id},"${r.product.name}","${r.product.brand}",${r.analysis.overallScore},${r.analysis.level.name},${r.scanMethod},${r.scannedAt.toIso8601String()}');
        }
        content = buffer.toString();
        mimeType = 'text/csv';
        fileName = 'ecoscan_history.csv';
      }

      final bytes = utf8.encode(content);
      await Share.shareXFiles(
        [
          XFile.fromData(
            bytes,
            mimeType: mimeType,
            name: fileName,
          )
        ],
        text: 'Lịch sử quét EcoScan AI',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi xuất dữ liệu: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final total =
        context.watch<HistoryCubit>().state.allRecords.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Xuất dữ liệu')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _InfoCard(total: total),
          const SizedBox(height: 20),
          const Text(
            'Chọn định dạng',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          _FormatTile(
            title: 'JSON',
            subtitle: 'Dữ liệu đầy đủ, dễ đọc bằng máy',
            icon: Icons.data_object,
            selected: _selectedFormat == 'json',
            onTap: () => setState(() => _selectedFormat = 'json'),
          ),
          const SizedBox(height: 8),
          _FormatTile(
            title: 'CSV',
            subtitle: 'Mở được trong Excel / Google Sheets',
            icon: Icons.table_chart_outlined,
            selected: _selectedFormat == 'csv',
            onTap: () => setState(() => _selectedFormat = 'csv'),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed:
                  (total == 0 || _exporting) ? null : _export,
              icon: _exporting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.download_outlined),
              label: Text(_exporting
                  ? 'Đang xuất...'
                  : 'Xuất ${_selectedFormat.toUpperCase()}'),
            ),
          ),
          if (total == 0) ...[
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Chưa có dữ liệu để xuất',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final int total;

  const _InfoCard({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$total bản ghi sẽ được xuất. Dữ liệu chỉ lưu trên thiết bị của bạn.',
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormatTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _FormatTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:
              selected ? AppColors.primary.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : Colors.grey[300]!,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                color:
                    selected ? AppColors.primary : Colors.grey[600]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: selected ? AppColors.primary : null)),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle,
                  color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
