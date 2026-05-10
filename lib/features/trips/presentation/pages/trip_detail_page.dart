import 'package:flutter/material.dart';

import '../../../../app/routes.dart';

class TripDetailPage extends StatelessWidget {
  final String tripId;

  const TripDetailPage({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('旅行详情'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('准备清单'),
                subtitle: const Text('查看并管理旅行准备项目'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, AppRoutes.checklist, arguments: tripId),
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('美食清单'),
                subtitle: const Text('记录想吃/已吃及花费'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, AppRoutes.foodChecklist, arguments: tripId),
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('注意事项'),
                subtitle: const Text('查看与记录旅行提醒'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, AppRoutes.notes, arguments: tripId),
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('应急卡'),
                subtitle: const Text('保存紧急联系方式与关键信息'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, AppRoutes.emergencyCard, arguments: tripId),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
