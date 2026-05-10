import 'package:flutter/material.dart';

import '../../../../core/database/app_database.dart';

class FoodChecklistPage extends StatefulWidget {
  final String tripId;

  const FoodChecklistPage({super.key, required this.tripId});

  @override
  State<FoodChecklistPage> createState() => _FoodChecklistPageState();
}

class _FoodChecklistPageState extends State<FoodChecklistPage> {
  static const statuses = ['全部', '想吃', '已吃', '跳过'];
  String _selectedStatus = '全部';
  late Future<List<Map<String, dynamic>>> _foodsFuture;

  @override
  void initState() {
    super.initState();
    _foodsFuture = AppDatabase.instance.queryByTripId('food_items', widget.tripId);
  }

  Future<void> _reload() async {
    setState(() {
      _foodsFuture = AppDatabase.instance.queryByTripId('food_items', widget.tripId);
    });
  }

  Future<void> _showFoodDialog({Map<String, dynamic>? item}) async {
    final name = TextEditingController(text: item?['name'] as String? ?? '');
    final area = TextEditingController(text: item?['area'] as String? ?? '');
    final address = TextEditingController(text: item?['address'] as String? ?? '');
    final dish = TextEditingController(text: item?['recommended_dish'] as String? ?? '');
    final budget = TextEditingController(text: (item?['budget'] as num?)?.toString() ?? '');
    final actual = TextEditingController(text: (item?['actual_cost'] as num?)?.toString() ?? '');
    final note = TextEditingController(text: item?['note'] as String? ?? '');
    String status = item?['status'] as String? ?? '想吃';
    double rating = (item?['rating'] as int? ?? 3).toDouble();

    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setInnerState) => AlertDialog(
          title: Text(item == null ? '添加美食' : '编辑美食'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: name, decoration: const InputDecoration(labelText: '名称*')),
                TextField(controller: area, decoration: const InputDecoration(labelText: '区域')),
                TextField(controller: address, decoration: const InputDecoration(labelText: '地址')),
                TextField(controller: dish, decoration: const InputDecoration(labelText: '推荐菜')),
                TextField(controller: budget, decoration: const InputDecoration(labelText: '预算'), keyboardType: TextInputType.number),
                TextField(controller: actual, decoration: const InputDecoration(labelText: '实际消费'), keyboardType: TextInputType.number),
                TextField(controller: note, decoration: const InputDecoration(labelText: '备注')),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: status,
                  items: const ['想吃', '已吃', '跳过']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setInnerState(() => status = v ?? '想吃'),
                  decoration: const InputDecoration(labelText: '状态'),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('评分'),
                    Expanded(
                      child: Slider(
                        min: 1,
                        max: 5,
                        divisions: 4,
                        value: rating,
                        label: rating.toInt().toString(),
                        onChanged: (v) => setInnerState(() => rating = v),
                      ),
                    ),
                    Text('${rating.toInt()}分'),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
            ElevatedButton(
              onPressed: () async {
                if (name.text.trim().isEmpty) return;
                final now = DateTime.now().toIso8601String();
                final payload = {
                  'trip_id': widget.tripId,
                  'name': name.text.trim(),
                  'area': area.text.trim(),
                  'address': address.text.trim(),
                  'recommended_dish': dish.text.trim(),
                  'budget': double.tryParse(budget.text.trim()),
                  'actual_cost': double.tryParse(actual.text.trim()),
                  'note': note.text.trim(),
                  'status': status,
                  'rating': rating.toInt(),
                  'updated_at': now,
                };
                if (item == null) {
                  await AppDatabase.instance.insert('food_items', {
                    'id': '${widget.tripId}_${DateTime.now().microsecondsSinceEpoch}',
                    ...payload,
                    'created_at': now,
                  });
                } else {
                  await AppDatabase.instance.updateById('food_items', item['id'] as String, payload);
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

  Future<void> _deleteFood(String id) async {
    await AppDatabase.instance.deleteById('food_items', id);
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('美食清单'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _foodsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final allItems = snapshot.data ?? [];
          final filtered = _selectedStatus == '全部'
              ? allItems
              : allItems.where((e) => (e['status'] as String? ?? '想吃') == _selectedStatus).toList();

          final totalBudget = filtered.fold<double>(0, (sum, item) => sum + ((item['budget'] as num?)?.toDouble() ?? 0));
          final totalActual = filtered.fold<double>(0, (sum, item) => sum + ((item['actual_cost'] as num?)?.toDouble() ?? 0));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        children: statuses
                            .map((status) => ChoiceChip(
                                  label: Text(status),
                                  selected: _selectedStatus == status,
                                  onSelected: (_) => setState(() => _selectedStatus = status),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 12),
                      Text('预算合计：${totalBudget.toStringAsFixed(2)}'),
                      Text('实际消费：${totalActual.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...filtered.map(
                (item) => Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(item['name'] as String? ?? ''),
                    subtitle: Text(
                      '状态：${item['status'] ?? '想吃'}\n预算：${(item['budget'] as num?)?.toStringAsFixed(2) ?? '-'}  实际：${(item['actual_cost'] as num?)?.toStringAsFixed(2) ?? '-'}\n推荐菜：${item['recommended_dish'] ?? '-'}',
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'edit') await _showFoodDialog(item: item);
                        if (value == 'delete') await _deleteFood(item['id'] as String);
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('编辑')),
                        PopupMenuItem(value: 'delete', child: Text('删除')),
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
        onPressed: () => _showFoodDialog(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        icon: const Icon(Icons.add),
        label: const Text('添加美食'),
      ),
    );
  }
}
