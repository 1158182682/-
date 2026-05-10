import 'package:flutter/material.dart';

import '../../../../core/database/app_database.dart';

class NotesPage extends StatefulWidget {
  final String tripId;

  const NotesPage({super.key, required this.tripId});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  static const noteTypes = ['安全', '交通', '支付', '风俗', '入境', '其他'];
  late Future<List<Map<String, dynamic>>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _notesFuture = AppDatabase.instance.queryByTripId('travel_notes', widget.tripId);
  }

  Future<void> _reload() async {
    setState(() {
      _notesFuture = AppDatabase.instance.queryByTripId('travel_notes', widget.tripId);
    });
  }

  Future<void> _showEditDialog({Map<String, dynamic>? note}) async {
    final title = TextEditingController(text: note?['title'] as String? ?? '');
    final content = TextEditingController(text: note?['content'] as String? ?? '');
    String selectedType = note?['type'] as String? ?? '其他';

    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setInnerState) => AlertDialog(
          title: Text(note == null ? '添加注意事项' : '编辑注意事项'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedType,
                  items: noteTypes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setInnerState(() => selectedType = v ?? '其他'),
                  decoration: const InputDecoration(labelText: '类型'),
                ),
                TextField(controller: title, decoration: const InputDecoration(labelText: '标题*')),
                TextField(controller: content, decoration: const InputDecoration(labelText: '内容'), maxLines: 3),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
            ElevatedButton(
              onPressed: () async {
                if (title.text.trim().isEmpty) return;
                final now = DateTime.now().toIso8601String();
                if (note == null) {
                  await AppDatabase.instance.insert('travel_notes', {
                    'id': '${widget.tripId}_${DateTime.now().microsecondsSinceEpoch}',
                    'trip_id': widget.tripId,
                    'type': selectedType,
                    'title': title.text.trim(),
                    'content': content.text.trim(),
                    'created_at': now,
                    'updated_at': now,
                  });
                } else {
                  await AppDatabase.instance.updateById('travel_notes', note['id'] as String, {
                    'type': selectedType,
                    'title': title.text.trim(),
                    'content': content.text.trim(),
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
        ),
      ),
    );
  }

  Future<void> _deleteNote(String id) async {
    await AppDatabase.instance.deleteById('travel_notes', id);
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('注意事项'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final notes = snapshot.data ?? [];
          if (notes.isEmpty) {
            return const Center(child: Text('暂无注意事项，点击右下角添加。'));
          }

          final grouped = <String, List<Map<String, dynamic>>>{};
          for (final note in notes) {
            final type = note['type'] as String? ?? '其他';
            grouped.putIfAbsent(type, () => []).add(note);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: grouped.entries
                .map(
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
                            (note) => ListTile(
                              title: Text(note['title'] as String? ?? ''),
                              subtitle: Text(note['content'] as String? ?? ''),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'edit') await _showEditDialog(note: note);
                                  if (value == 'delete') await _deleteNote(note['id'] as String);
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
                )
                .toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEditDialog(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        icon: const Icon(Icons.add),
        label: const Text('添加注意事项'),
      ),
    );
  }
}
