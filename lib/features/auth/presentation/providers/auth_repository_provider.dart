import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meteokite/core/storage/database_provider.dart';
import 'package:meteokite/features/auth/data/local/auth_local_data_source.dart';
import 'package:meteokite/features/auth/data/remote/social_auth_remote_data_source.dart';
import 'package:meteokite/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:meteokite/features/auth/domain/repositories/auth_repository.dart';

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final db = ref.watch(localDatabaseProvider);
  return AuthLocalDataSource(db);
});

final socialAuthRemoteDataSourceProvider = Provider<SocialAuthRemoteDataSource>(
  (ref) {
    return const SocialAuthRemoteDataSource();
  },
);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final local = ref.watch(authLocalDataSourceProvider);
  final social = ref.watch(socialAuthRemoteDataSourceProvider);
  return AuthRepositoryImpl(local: local, socialRemote: social);
});

final recentAuthEmailsProvider = StreamProvider<List<String>>((ref) {
  final local = ref.watch(authLocalDataSourceProvider);
  return local.watchRecentEmails(limit: 6);
});

final recentAuthAccountsActionsProvider = Provider<RecentAuthAccountsActions>((
  ref,
) {
  final local = ref.watch(authLocalDataSourceProvider);
  return RecentAuthAccountsActions(local);
});

class RecentAuthAccountsActions {
  const RecentAuthAccountsActions(this._local);

  final AuthLocalDataSource _local;

  Future<void> remove(String email) {
    return _local.removeRecentEmail(email);
  }
}
