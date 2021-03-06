import 'package:flutter/cupertino.dart';
import 'package:flutter_cource_todo_2/controllers/auth_controller.dart';
import 'package:flutter_cource_todo_2/exceptions/custom_exception.dart';

import 'package:flutter_cource_todo_2/repository/item_repository.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/item.dart';

final itemListExceptionProvider = StateProvider<CustomException?>((ref) {
  return null;
});
final itemListControllerProvider = Provider<ItemListController>((ref) {
  final userId = ref.watch(authControllerProvider.state)?.uid;
  return ItemListController(ref.read, userId!);
});

class ItemListController extends StateNotifier<AsyncValue<List<Item>>> {
  final Reader _read;
  final String? _userId;
  ItemListController(this._read, this._userId) : super(AsyncValue.loading()) {
    if (_userId != null) retrieveItem(_userId!);
  }
  Future<List<Item>?> retrieveItem(String userId) async {
    try {
      final items =
          await _read(itemRepositoryProvider).retrieveItem(userId: userId);
      if (mounted) state = AsyncValue.data(items!);
    } on CustomException catch (e, st) {
      throw AsyncValue.error(e, st);
    }
  }

  Future<void> createItem({bool obtained = false, String? name}) async {
    try {
      final item = Item(name: name, obtainded: obtained);
      final itemId = await _read(itemRepositoryProvider)
          .createItem(userId: _userId, item: item);
      state.whenData((items) => items.add(item.copyWith(id: itemId)));
    } on CustomException catch (e) {
      _read(itemListExceptionProvider).state = e;
    }
  }

  Future<void> updateItem({Item? updatedItem}) async {
    try {
      _read(itemRepositoryProvider)
          .updateItem(userId: _userId, item: updatedItem!);
      state.whenData((items) {
        state = AsyncValue.data([
          for (final item in items)
            if (item.id == updatedItem.id) updatedItem else item
        ]);
      });
    } on CustomException catch (e) {
      _read(itemListExceptionProvider).state = e;
    }
  }

  Future<void> deleteItem({String? itemId}) async {
    try {
      await _read(itemRepositoryProvider)
          .deleteItem(userId: _userId, itemId: itemId!);
      state.whenData((items) {
        state = AsyncValue.data(
          items..removeWhere((item) => item.id == itemId),
        );
      });
    } on CustomException catch (e) {
      _read(itemListExceptionProvider).state = e;
    }
  }
}
