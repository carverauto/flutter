// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserData _$$_UserDataFromJson(Map<String, dynamic> json) => _$_UserData(
      uid: json['uid'] as String,
      userName: json['userName'] as String,
      email: json['email'] as String,
      photoURL: json['photoURL'] as String?,
      lastUpdated: json['lastUpdated'] as int,
    );

Map<String, dynamic> _$$_UserDataToJson(_$_UserData instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'userName': instance.userName,
      'email': instance.email,
      'photoURL': instance.photoURL,
      'lastUpdated': instance.lastUpdated,
    };
