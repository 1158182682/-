import 'package:flutter/material.dart';

import '../../../../core/database/app_database.dart';

class EmergencyCardPage extends StatefulWidget {
  final String tripId;

  const EmergencyCardPage({super.key, required this.tripId});

  @override
  State<EmergencyCardPage> createState() => _EmergencyCardPageState();
}

class _EmergencyCardPageState extends State<EmergencyCardPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _contactName = TextEditingController();
  final _contactPhone = TextEditingController();
  final _hotelAddress = TextEditingController();
  final _passportNumber = TextEditingController();
  final _insurancePhone = TextEditingController();
  final _policePhone = TextEditingController();
  final _ambulancePhone = TextEditingController();
  final _embassyPhone = TextEditingController();

  String? _cardId;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cards = await AppDatabase.instance.queryByTripId('emergency_cards', widget.tripId);
    if (cards.isNotEmpty) {
      final card = cards.first;
      _cardId = card['id'] as String?;
      _name.text = card['name'] as String? ?? '';
      _contactName.text = card['emergency_contact_name'] as String? ?? '';
      _contactPhone.text = card['emergency_contact_phone'] as String? ?? '';
      _hotelAddress.text = card['hotel_address'] as String? ?? '';
      _passportNumber.text = card['passport_number'] as String? ?? '';
      _insurancePhone.text = card['insurance_phone'] as String? ?? '';
      _policePhone.text = card['police_phone'] as String? ?? '';
      _ambulancePhone.text = card['ambulance_phone'] as String? ?? '';
      _embassyPhone.text = card['embassy_phone'] as String? ?? '';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final payload = {
        'trip_id': widget.tripId,
        'name': _name.text.trim(),
        'emergency_contact_name': _contactName.text.trim(),
        'emergency_contact_phone': _contactPhone.text.trim(),
        'hotel_address': _hotelAddress.text.trim(),
        'passport_number': _passportNumber.text.trim(),
        'insurance_phone': _insurancePhone.text.trim(),
        'police_phone': _policePhone.text.trim(),
        'ambulance_phone': _ambulancePhone.text.trim(),
        'embassy_phone': _embassyPhone.text.trim(),
      };
      if (_cardId == null) {
        _cardId = '${widget.tripId}_${DateTime.now().microsecondsSinceEpoch}';
        await AppDatabase.instance.insert('emergency_cards', {
          'id': _cardId,
          ...payload,
        });
      } else {
        await AppDatabase.instance.updateById('emergency_cards', _cardId!, payload);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('应急卡已保存到本机')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _field(String label, TextEditingController c, {String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        validator: validator,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('应急卡'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _field('姓名', _name, validator: (v) => (v == null || v.trim().isEmpty) ? '请输入姓名' : null),
                        _field('紧急联系人', _contactName),
                        _field('紧急联系人电话', _contactPhone),
                        _field('酒店地址', _hotelAddress),
                        _field('护照号码', _passportNumber),
                        const Text('提示：护照号码仅保存在本机。', style: TextStyle(color: Colors.redAccent)),
                        const SizedBox(height: 12),
                        _field('保险电话', _insurancePhone),
                        _field('当地报警电话', _policePhone),
                        _field('当地急救电话', _ambulancePhone),
                        _field('中国使领馆电话', _embassyPhone),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _saving ? null : _save,
                          child: _saving
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Text('保存应急卡'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
