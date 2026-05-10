import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/routes.dart';
import '../../../../core/database/app_database.dart';

class TripListPage extends StatefulWidget {
  const TripListPage({super.key});

  @override
  State<TripListPage> createState() => _TripListPageState();
}

class _TripListPageState extends State<TripListPage> {
  late Future<List<Map<String, dynamic>>> _tripsFuture;

  @override
  void initState() {
    super.initState();
    _tripsFuture = AppDatabase.instance.queryAll('trips');
  }

  Future<void> _reload() async {
    setState(() {
      _tripsFuture = AppDatabase.instance.queryAll('trips');
    });
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '-';
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return '-';
    return DateFormat('yyyy-MM-dd').format(parsed);
  }

  Future<double> _progressOfTrip(String tripId) async {
    final items = await AppDatabase.instance.queryByTripId('checklist_items', tripId);
    if (items.isEmpty) return 0;
    final checked = items.where((e) => (e['is_checked'] as int? ?? 0) == 1).length;
    return checked / items.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('旅备清单'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _tripsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(child: Text('加载失败，请下拉重试')),
                ],
              );
            }

            final trips = snapshot.data ?? [];
            if (trips.isEmpty) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  SizedBox(height: 120),
                  Center(child: Text('还没有旅行，点击右下角开始创建吧。')),
                ],
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                final tripId = trip['id'] as String? ?? '';
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.tripDetail,
                      arguments: tripId,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip['title'] as String? ?? '未命名旅行',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          Text('目的地：${trip['destination'] as String? ?? '-'}'),
                          Text('出发日期：${_formatDate(trip['start_date'] as String?)}'),
                          const SizedBox(height: 10),
                          FutureBuilder<double>(
                            future: _progressOfTrip(tripId),
                            builder: (context, progressSnapshot) {
                              final progress = progressSnapshot.data ?? 0;
                              final percent = (progress * 100).toStringAsFixed(0);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('准备进度：$percent%'),
                                  const SizedBox(height: 6),
                                  LinearProgressIndicator(value: progress),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, AppRoutes.createTrip);
          await _reload();
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        label: const Text('创建旅行'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
