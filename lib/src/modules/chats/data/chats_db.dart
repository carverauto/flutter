import 'dart:convert';
import 'dart:developer';

import 'package:chaseapp/flavors.dart';
import 'package:chaseapp/src/modules/chats/data/chats_db_ab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ChatsDatabase implements ChatsDatabaseAB {
  ChatsDatabase(this.read);

  final Reader read;
  @override
  Future<String> getUserToken(String userId) async {
    // final getToken = read(functionsProvider).httpsCallable("GetStreamToken");

    // final HttpsCallableResult<dynamic> responce =
    //     await getToken.call<Map<String, dynamic>>({"user_id": userId});
    //Move id/endpoints to someplace better
    final projectId =
        F.appFlavor == Flavor.DEV ? "chaseapp-staging" : "chaseapp-8459b";

    final url = Uri.parse(
        "https://us-central1-$projectId.cloudfunctions.net/GetStreamToken");

    final responce = await http.post(url,
        headers: {
          //  "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": userId,
        }));

    log(responce.body.toString());

    final Map<String, dynamic> decodedData =
        jsonDecode(responce.body) as Map<String, dynamic>;

    return decodedData["data"]["message"] as String;
  }
}
