Set<int> newlyActivatedAlertIds({
  required Set<int> previousActiveIds,
  required Set<int> currentActiveIds,
}) {
  return currentActiveIds.difference(previousActiveIds);
}

bool shouldNotifyAlertActivation({
  required DateTime now,
  required DateTime? lastNotifiedAt,
  Duration debounce = const Duration(minutes: 2),
}) {
  if (lastNotifiedAt == null) {
    return true;
  }
  return now.difference(lastNotifiedAt) >= debounce;
}
