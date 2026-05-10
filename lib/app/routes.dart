import 'package:flutter/material.dart';

import '../features/checklist/presentation/pages/checklist_page.dart';
import '../features/emergency/presentation/pages/emergency_card_page.dart';
import '../features/food/presentation/pages/food_checklist_page.dart';
import '../features/notes/presentation/pages/notes_page.dart';
import '../features/trips/presentation/pages/create_trip_page.dart';
import '../features/trips/presentation/pages/trip_detail_page.dart';
import '../features/trips/presentation/pages/trip_list_page.dart';

class AppRoutes {
  static const home = '/';
  static const createTrip = '/trip/create';
  static const tripDetail = '/trip/detail';
  static const checklist = '/checklist';
  static const foodChecklist = '/food';
  static const notes = '/notes';
  static const emergencyCard = '/emergency';

  static Map<String, WidgetBuilder> get routes => {
        home: (_) => const TripListPage(),
        createTrip: (_) => const CreateTripPage(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == tripDetail) {
      final tripId = settings.arguments as String;
      return MaterialPageRoute(builder: (_) => TripDetailPage(tripId: tripId));
    }
    if (settings.name == checklist) {
      final tripId = settings.arguments as String;
      return MaterialPageRoute(builder: (_) => ChecklistPage(tripId: tripId));
    }
    if (settings.name == foodChecklist) {
      final tripId = settings.arguments as String;
      return MaterialPageRoute(builder: (_) => FoodChecklistPage(tripId: tripId));
    }
    if (settings.name == notes) {
      final tripId = settings.arguments as String;
      return MaterialPageRoute(builder: (_) => NotesPage(tripId: tripId));
    }
    if (settings.name == emergencyCard) {
      final tripId = settings.arguments as String;
      return MaterialPageRoute(builder: (_) => EmergencyCardPage(tripId: tripId));
    }
    return null;
  }
}
