import 'package:chaseapp/src/core/modules/chase/data/chase_db.dart';
import 'package:chaseapp/src/core/modules/chase/data/chase_db_ab.dart';
import 'package:chaseapp/src/core/modules/chase/domain/chase_repo.dart';
import 'package:chaseapp/src/core/modules/chase/domain/chase_repo_ab.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferancesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final chaseDbProvider =
    Provider<ChaseDbAB>((ref) => ChaseDatabase(read: ref.read));

final chaseRepoProvider =
    Provider<ChaseRepoAB>((ref) => ChaseRepository(read: ref.read));

final streamChasesProvider = StreamProvider<List<Chase>>(
    (ref) => ref.watch(chaseRepoProvider).streamChases());
final streamChaseProvider = StreamProvider.family<Chase, String>(
    (ref, chaseId) => ref.watch(chaseRepoProvider).streamChase(chaseId));
