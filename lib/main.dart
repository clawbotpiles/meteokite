import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteokite/app/app.dart';
import 'package:meteokite/core/notifications/local_notifications_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationsService.instance.initialize();
  await LocalNotificationsService.instance.requestPermissionsIfNeeded();
  runApp(const ProviderScope(child: MeteoKiteApp()));
}
