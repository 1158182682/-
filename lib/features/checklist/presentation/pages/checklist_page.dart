import 'package:flutter/material.dart';

import '../../../../core/database/app_database.dart';

class ChecklistPage extends StatefulWidget {
  final String tripId;

  const ChecklistPage({super.key, required this.tripId});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  late Future<List<Map<String, dynamic>>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = AppDatabase.instance.queryByTripId('checklist_items', widget.tripId);
  }

  Future<void> _reload() async {
    setState(() {
      _itemsFuture = AppDatabase.instance.queryByTripId('checklist_items', widget.tripId);
    });
  }

  Future<void> _toggleItem(Map<String, dynamic> item) async {
    final checked = (item['is_checked'] as int? ?? 0) == 1 ? 0 : 1;
    await AppDatabase.instance.updateById('checklist_items', item['id'] as String, {
      'is_checked': checked,
      'updated_at': DateTime.now().toIso8601String(),
    });
    await _reload();
  }

  Future<void> _showEditDialog({Map<String, dynamic>? item}) async {
    final titleController = TextEditingController(text: item?['title'] as String? ?? '');
    final noteController = TextEditingController(text: item?['note'] as String? ?? '');
    final categoryController = TextEditingController(text: item?['category'] as String? ?? '其他');

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item == null ? '新增清单项目' : '编辑清单项目'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: categoryController, decoration: const InputDecoration(labelText: '分类')),
                TextField(controller: titleController, decoration: const InputDecoration(labelText: '项目名称')),
                TextField(controller: noteController, decoration: const InputDecoration(labelText: '备注')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                if (title.isEmpty) return;
                final now = DateTime.now().toIso8601String();
                if (item == null) {
                  final allItems = await AppDatabase.instance.queryByTripId('checklist_items', widget.tripId);
                  await AppDatabase.instance.insert('checklist_items', {
                    'id': '${widget.tripId}_${DateTime.now().microsecondsSinceEpoch}',
                    'trip_id': widget.tripId,
                    'category': categoryController.text.trim().isEmpty ? '其他' : categoryController.text.trim(),
                    'title': title,
                    'note': noteController.text.trim(),
                    'quantity': 1,
                    'is_checked': 0,
                    'sort_order': allItems.length,
                    'created_at': now,
                    'updated_at': now,
                  });
                } else {
                  await AppDatabase.instance.updateById('checklist_items', item['id'] as String, {
                    'category': categoryController.text.trim().isEmpty ? '其他' : categoryController.text.trim(),
                    'title': title,
                    'note': noteController.text.trim(),
                    'updated_at': now,
                  });
                }
                if (!mounted) return;
                Navigator.pop(context);
                await _reload();
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteItem(String id) async {
    await AppDatabase.instance.deleteById('checklist_items', id);
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('准备清单'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('加载失败'));
          }

          final items = snapshot.data ?? [];
          final checkedCount = items.where((item) => (item['is_checked'] as int? ?? 0) == 1).length;
          final grouped = <String, List<Map<String, dynamic>>>{};
          for (final item in items) {
            final category = item['category'] as String? ?? '其他';
            grouped.putIfAbsent(category, () => []).add(item);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '准备进度：$checkedCount / ${items.length}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...grouped.entries.map(
                (entry) => Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(entry.key, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                        ...entry.value.map(
                          (item) => CheckboxListTile(
                            value: (item['is_checked'] as int? ?? 0) == 1,
                            onChanged: (_) => _toggleItem(item),
                            title: Text(item['title'] as String? ?? ''),
                            subtitle: ((item['note'] as String? ?? '').isNotEmpty)
                                ? Text(item['note'] as String)
                                : null,
                            controlAffinity: ListTileControlAffinity.leading,
                            secondary: PopupMenuButton<String>(
                              onSelected: (value) async {
                                if (value == 'edit') {
                                  await _showEditDialog(item: item);
                                }
                                if (value == 'delete') {
                                  await _deleteItem(item['id'] as String);
                                }
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(value: 'edit', child: Text('编辑')),
                                PopupMenuItem(value: 'delete', child: Text('删除')),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEditDialog(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        icon: const Icon(Icons.add),
        label: const Text('新增项目'),
      ),
    );
  }
}
