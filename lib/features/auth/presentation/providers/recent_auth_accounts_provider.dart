import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final _recentAuthEmailsStateProvider =
    NotifierProvider<_RecentAuthEmailsNotifier, List<String>>(
      _RecentAuthEmailsNotifier.new,
    );

class _RecentAuthEmailsNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => const <String>[];

  void replace(List<String> emails) {
    state = emails;
  }
}

final recentAuthEmailsProvider = FutureProvider<List<String>>((ref) async {
  return ref.watch(_recentAuthEmailsStateProvider);
});

final recentAuthAccountsActionsProvider = Provider<RecentAuthAccountsActions>(
  (ref) => RecentAuthAccountsActions(ref),
);

class RecentAuthAccountsActions {
  RecentAuthAccountsActions(this._ref);

  final Ref _ref;

  Future<void> add(String email) async {
    final normalized = email.trim().toLowerCase();
    if (normalized.isEmpty) {
      return;
    }

    final current = _ref.read(_recentAuthEmailsStateProvider);
    final next = <String>[
      normalized,
      ...current.where((e) => e != normalized),
    ].take(10).toList();
    _ref.read(_recentAuthEmailsStateProvider.notifier).replace(next);
  }

  Future<void> remove(String email) async {
    final normalized = email.trim().toLowerCase();
    final current = _ref.read(_recentAuthEmailsStateProvider);
    _ref
        .read(_recentAuthEmailsStateProvider.notifier)
        .replace(current.where((entry) => entry != normalized).toList());
  }
}
