class EmergencyCardModel {
  final String id;
  final String tripId;
  final String name;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? hotelAddress;
  final String? passportNumber;
  final String? insurancePhone;
  final String? policePhone;
  final String? ambulancePhone;
  final String? embassyPhone;

  const EmergencyCardModel({
    required this.id,
    required this.tripId,
    required this.name,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.hotelAddress,
    this.passportNumber,
    this.insurancePhone,
    this.policePhone,
    this.ambulancePhone,
    this.embassyPhone,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'trip_id': tripId,
        'name': name,
        'emergency_contact_name': emergencyContactName,
        'emergency_contact_phone': emergencyContactPhone,
        'hotel_address': hotelAddress,
        'passport_number': passportNumber,
        'insurance_phone': insurancePhone,
        'police_phone': policePhone,
        'ambulance_phone': ambulancePhone,
        'embassy_phone': embassyPhone,
      };

  factory EmergencyCardModel.fromMap(Map<String, dynamic> map) => EmergencyCardModel(
        id: map['id'] as String,
        tripId: map['trip_id'] as String? ?? '',
        name: map['name'] as String? ?? '',
        emergencyContactName: map['emergency_contact_name'] as String?,
        emergencyContactPhone: map['emergency_contact_phone'] as String?,
        hotelAddress: map['hotel_address'] as String?,
        passportNumber: map['passport_number'] as String?,
        insurancePhone: map['insurance_phone'] as String?,
        policePhone: map['police_phone'] as String?,
        ambulancePhone: map['ambulance_phone'] as String?,
        embassyPhone: map['embassy_phone'] as String?,
      );
}
