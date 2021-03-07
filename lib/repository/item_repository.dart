import 'package:cloud_firestore/cloud_firestore.dart';
import '../extensions/firebase_firestore_extensions.dart';
import 'package:flutter_cource_todo_2/exceptions/custom_exception.dart';
import 'package:flutter_cource_todo_2/models/item.dart';
import 'package:flutter_cource_todo_2/providers/general_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseItemRepository {
  Future<List<Item>?> retrieveItem({required String userId});
  Future<String> createItem({required String userId, required Item item});
  Future<void> updateItem({required String userId, required Item item});
  Future<void> deleteItem({required String userId, required String itemId});
}

final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  return ItemRepository(ref.read);
});

class ItemRepository extends BaseItemRepository {
  final Reader _read;
  ItemRepository(this._read);
  @override
  Future<String> createItem({String? userId, Item? item}) async {
    try {
      var doc = await _read(firebaseFirestoreProvider)
          .userListRef(userId!)
          .add(item!.toDocument());
      return doc.id;
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> deleteItem({String? userId, String? itemId}) async {
    try {
      return await _read(firebaseFirestoreProvider)
          .userListRef(userId!)
          .doc(itemId)
          .delete();
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<List<Item>?> retrieveItem({String? userId}) async {
    try {
      var snap =
          await _read(firebaseFirestoreProvider).userListRef(userId!).get();
      return snap.docs.map((e) => Item.fromDocument(e)).toList();
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> updateItem({String? userId, Item? item}) async {
    try {
      return await _read(firebaseFirestoreProvider)
          .userListRef(userId!)
          .doc(item!.id)
          .update(item.toJson());
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}
