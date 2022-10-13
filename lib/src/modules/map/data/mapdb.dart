import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

import '../../../models/adsb/adsb.dart';
import '../../../models/ship/ship.dart';

class MapDB {
  Future<MapMarkersData> getRTDBData() async {
    final DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref();
    final DataSnapshot data = await firebaseDatabase.child('adsb').get();
    final DataSnapshot shipsData =
        await firebaseDatabase.child('ships/1').get();

    log(shipsData.value.toString());
    if (data.exists) {
      final String encodedData = jsonEncode(data.value);
      final String encodedShipsData = jsonEncode(shipsData.value);

      final Map<String, dynamic> bofList =
          jsonDecode(encodedData) as Map<String, dynamic>;

      final List<ADSB> bofs = bofList.values.map((dynamic e) {
        return ADSB.fromJson(e as Map<String, dynamic>);
      }).toList();
      final List<dynamic> shipsList =
          jsonDecode(encodedShipsData) as List<dynamic>;

      final List<Ship> ships = shipsList.map((dynamic e) {
        return Ship.fromJson(e as Map<String, dynamic>);
      }).toList();

      return MapMarkersData(
        adsbs: bofs,
        ships: ships,
      );
    } else {
      return MapMarkersData(
        adsbs: <ADSB>[],
        ships: <Ship>[],
      );
    }
  }
}

class MapMarkersData {
  MapMarkersData({
    required this.ships,
    required this.adsbs,
  });

  final List<Ship> ships;
  final List<ADSB> adsbs;
}
