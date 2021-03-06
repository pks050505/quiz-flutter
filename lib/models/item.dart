import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';
part 'item.g.dart';

@freezed
abstract class Item with _$Item {
  factory Item({
    String? id,
    String? name,
    @Default(false) bool obtainded,
  }) = _Item;
  factory Item.empty() => Item(name: '');
  factory Item.fromDocument(DocumentSnapshot? snap) {
    var data = snap?.data();
    return Item.fromJson(data!).copyWith(id: snap?.id);
  }

  // Map<String, dynamic> toDocument() => toJson()..remove('id');
  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}
