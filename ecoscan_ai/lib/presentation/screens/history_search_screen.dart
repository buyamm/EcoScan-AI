import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/history/history_cubit.dart';
import '../widgets/product_list_tile.dart';

class HistorySearchScreen extends StatefulWidget {
  const HistorySearchScreen({super.key});

  @override
  State<HistorySearchScreen> createState() => _HistorySearchScreenState();
}

class _HistorySearchScreenState extends State<HistorySearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'Tìm kiếm sản phẩm...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (query) =>
              context.read<HistoryCubit>().search(query),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              context.read<HistoryCubit>().search('');
            },
          ),
        ],
      ),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          final query = state.searchQuery;
          if (query.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  Text(
                    'Nhập tên sản phẩm để tìm kiếm',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                ],
              ),
            );
          }
          final results = state.filteredRecords;
          if (results.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🔍', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text(
                    'Không tìm thấy "$query"',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.only(
              top: 8,
              bottom: 8 + MediaQuery.of(context).viewPadding.bottom,
            ),
            itemCount: results.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, indent: 16),
            itemBuilder: (context, index) {
              final record = results[index];
              return ProductListTile.fromScanRecord(
                record,
                onTap: () =>
                    context.push('/history/detail', extra: record),
              );
            },
          );
        },
      ),
    );
  }
}
