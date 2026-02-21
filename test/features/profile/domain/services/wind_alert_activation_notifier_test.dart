import 'package:flutter_test/flutter_test.dart';
import 'package:meteokite/features/profile/domain/services/wind_alert_activation_notifier.dart';

void main() {
  test('detects newly activated alert ids', () {
    final result = newlyActivatedAlertIds(
      previousActiveIds: {1, 2},
      currentActiveIds: {2, 3, 4},
    );

    expect(result, {3, 4});
  });

  test('allows first notification when no previous timestamp', () {
    final shouldNotify = shouldNotifyAlertActivation(
      now: DateTime.utc(2026, 2, 21, 12, 0),
      lastNotifiedAt: null,
    );

    expect(shouldNotify, isTrue);
  });

  test('blocks notifications inside debounce window', () {
    final now = DateTime.utc(2026, 2, 21, 12, 1);
    final last = DateTime.utc(2026, 2, 21, 12, 0);

    final shouldNotify = shouldNotifyAlertActivation(
      now: now,
      lastNotifiedAt: last,
      debounce: const Duration(minutes: 2),
    );

    expect(shouldNotify, isFalse);
  });
}
