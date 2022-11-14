import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/activeTFR/activeTFR.dart';
import '../../../models/adsb/adsb.dart';
import '../../../models/ship/ship.dart';
import '../../../models/weather/weather.dart';
import '../../../models/weather/weather_station/weather_station.dart';
import '../../../shared/util/firebase_collections.dart';

class MapDB {
  MapDB({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  static final DatabaseReference _firebaseDatabase =
      FirebaseDatabase.instance.ref();
  static final FirebaseFirestore _firestoreReferance =
      FirebaseFirestore.instance;
  final DatabaseReference _adsbRef = _firebaseDatabase.child('adsb');
  final DatabaseReference _shipsRef = _firebaseDatabase.child('ships/1');
  final DatabaseReference _tfrRef =
      _firebaseDatabase.child('tfr/activeTFRs/features');

  Future<List<double>?> get getLastMapCenteredCoordinates async {
    final List<String>? lastMapCenteredCoordinates =
        sharedPreferences.getStringList('lastMapCenteredCoordinates');

    return lastMapCenteredCoordinates?.map(double.parse).toList();
  }

  Future<void> setLastMapCenteredCoordinates(
    List<double> coordinates,
  ) async {
    await sharedPreferences.setStringList(
      'lastMapCenteredCoordinates',
      coordinates.map((double e) => e.toString()).toList(),
    );
  }

  Stream<List<ADSB>> adsbStream() {
    return _adsbRef.onValue.map((DatabaseEvent event) {
      if (event.snapshot.exists) {
        final DataSnapshot data = event.snapshot;
        final String encodedData = jsonEncode(data.value);

        final Map<String, dynamic> adsbMap =
            jsonDecode(encodedData) as Map<String, dynamic>;

        final List<ADSB> adsbList = adsbMap
            .map<String, ADSB>((String key, dynamic value) {
              final Map<String, dynamic> data = value as Map<String, dynamic>;
              data['id'] = key;

              return MapEntry<String, ADSB>(
                key,
                ADSB.fromJson(data),
              );
            })
            .values
            .toList();

        return adsbList;
      } else {
        return [];
      }
    });
  }

  Stream<List<Ship>> shipsStream() {
    return _shipsRef.onValue.map((DatabaseEvent event) {
      if (event.snapshot.exists) {
        final DataSnapshot data = event.snapshot;

        final String encodedData = jsonEncode(data.value);

        final List<dynamic> shipsList =
            jsonDecode(encodedData) as List<dynamic>;

        final List<Ship> ships = shipsList
            .asMap()
            .map<int, Ship>((int index, dynamic value) {
              final Map<String, dynamic> data = value as Map<String, dynamic>;
              data['id'] = index.toString();

              return MapEntry<int, Ship>(
                index,
                Ship.fromJson(data),
              );
            })
            .values
            .toList();

        return ships;
      } else {
        return [];
      }
    });
  }

  Stream<List<ActiveTFR>> activeTFRsStream() {
    return _tfrRef.onValue.map((DatabaseEvent event) {
      if (event.snapshot.exists) {
        final DataSnapshot data = event.snapshot;

        final String encodedData = jsonEncode(data.value);

        final List<dynamic> activeTFRsList =
            jsonDecode(encodedData) as List<dynamic>;

        final List<ActiveTFR> activeTFRs = activeTFRsList
            .asMap()
            .map<int, ActiveTFR>((int index, dynamic value) {
              final Map<String, dynamic> data = value as Map<String, dynamic>;

              return MapEntry<int, ActiveTFR>(
                index,
                ActiveTFR.fromJson(data),
              );
            })
            .values
            .toList();

        return activeTFRs;
      } else {
        return [];
      }
    });
  }

  Stream<List<Weather>> get weatherStormSurgesStream {
    return stormSurgeAlertsRef.snapshots().map((QuerySnapshot<Weather> event) {
      if (event.docs.isNotEmpty) {
        final List<QueryDocumentSnapshot<Weather>> data = event.docs;
        final List<Weather> weather =
            data.map((QueryDocumentSnapshot<Weather> e) {
          final Weather weather = e.data();
          final List<WeatherStation> activeStations = weather.stations
              .where((WeatherStation station) => station.stormesurge)
              .toList();
          final Weather finalWeather =
              weather.copyWith(stations: activeStations);

          return finalWeather;
        }).toList();

        final List<Weather> finalWeather = weather
            .where((Weather weather) => weather.stations.isNotEmpty)
            .toList();

        return finalWeather;
      } else {
        return [];
      }
    });
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
