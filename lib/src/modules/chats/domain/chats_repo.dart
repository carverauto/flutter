import 'package:chaseapp/src/modules/chats/data/chats_db_ab.dart';
import 'package:chaseapp/src/modules/chats/domain/chats_repo_ab.dart';

class ChatsRepository implements ChatsRepositoryAB {
  ChatsRepository({required this.db});

  final ChatsDatabaseAB db;

  @override
  Future<String> getUserToken(String userId) {
    return db.getUserToken(userId);
  }
}
