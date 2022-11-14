import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../core/top_level_providers/firebase_providers.dart';
import 'chats_db_ab.dart';

class ChatsDatabase implements ChatsDatabaseAB {
  ChatsDatabase(this.read);

  final Reader read;
  @override
  Future<String> getUserToken(String userId) async {
    log('Getting User Token');
    final String projectId = read(firebaseAuthProvider).app.options.projectId;
    final Uri url = Uri.parse(
      'https://us-central1-$projectId.cloudfunctions.net/GetStreamToken',
    );

    final http.Response responce = await http.post(
      url,
      headers: {
        //  "Content-Type": "application/json",
      },
      body: jsonEncode({
        'user_id': userId,
      }),
    );

    log(responce.body);

    final Map<String, dynamic> decodedData =
        jsonDecode(responce.body) as Map<String, dynamic>;

    return decodedData['data']['message'] as String;
  }
}
