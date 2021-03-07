// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Item _$_$_ItemFromJson(Map<String, dynamic> json) {
  return _$_Item(
    id: json['id'] as String?,
    name: json['name'] as String,
    obtainded: json['obtainded'] as bool? ?? false,
  );
}

Map<String, dynamic> _$_$_ItemToJson(_$_Item instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'obtainded': instance.obtainded,
    };
