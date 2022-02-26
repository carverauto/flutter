import 'dart:developer';

import 'package:chaseapp/src/core/top_level_providers/firebase_providers.dart';
import 'package:chaseapp/src/modules/chats/data/chats_db_ab.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatsDatabase implements ChatsDatabaseAB {
  ChatsDatabase(this.read);

  final Reader read;
  @override
  Future<String> getUserToken(String userId) async {
    final getToken = read(functionsProvider).httpsCallable("GetStreamToken");

    final HttpsCallableResult<dynamic> responce =
        await getToken.call<Map<String, dynamic>>({"user_id": userId});

    log(responce.data.toString());

    final Map<String, dynamic> data = responce.data as Map<String, dynamic>;

    return data["message"] as String;
  }
}
