import 'dart:async';
import 'dart:developer';

import 'package:chaseapp/src/models/pagination_state/pagination_notifier_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class PaginationNotifier<T> extends StateNotifier<PaginationNotifierState<T>> {
  PaginationNotifier({required this.fetchNextItems, required this.hitsPerPage})
      : super(const PaginationNotifierState.data([], false)) {
    init();
  }

  final Logger logger = Logger('PaginationNotifier');
  final Future<List<T>> Function(T? item, int offset) fetchNextItems;
  final int hitsPerPage;

  final List<T> _items = [];
  OnGoingState onGoingState = OnGoingState.Idle;

  Timer _timer = Timer(Duration(milliseconds: 500), () {});

  bool get isFetching => onGoingState == OnGoingState.Loading;

  void init() {
    if (_items.isEmpty) {
      _timer.cancel();
      fetchNextPage();
    }
  }

  bool get _canLoadNextPage => state.maybeWhen(
        loading: (_) => false,
        data: (_, hasReachedMax) => !hasReachedMax,
        orElse: () => true,
      );

  Future<void> fetchNextPage({
    bool clearCurrentList = false,
  }) async {
    if (_timer.isActive && _items.isNotEmpty) {
      return;
    }
    _timer = Timer(Duration(milliseconds: 1000), () {});

    if (!mounted) {
      logger.warning("fetchNextPage called on unmounted PaginationNotifier");
      return;
    }
    if (!_canLoadNextPage) {
      return;
    }

    if (_items.isEmpty) {
      try {
        state = PaginationNotifierState.loading(_items);
        final List<T> result = _items.isEmpty || clearCurrentList
            ? await fetchNextItems(
                null,
                0,
              )
            : await fetchNextItems(_items.last, _items.length);
        if (clearCurrentList) {
          _items.clear();
        }
        if (result.isEmpty) {
          state = PaginationNotifierState.data(_items, true);
        } else if (result.length < hitsPerPage) {
          state = PaginationNotifierState.data(_items..addAll(result), true);
        } else {
          state = PaginationNotifierState.data(_items..addAll(result), false);
        }
      } catch (e, stk) {
        print(mounted);
        state = PaginationNotifierState.error(e, stk);
      }
    } else {
      if (onGoingState == OnGoingState.Loading) {
        return;
      }
      log('nope');
      try {
        onGoingState = OnGoingState.Loading;
        state = PaginationNotifierState.data(_items, true);
        final result = await fetchNextItems(_items.last, _items.length);
        if (result.isEmpty) {
          state = PaginationNotifierState.data(_items, true);
        } else if (result.length < hitsPerPage) {
          state = PaginationNotifierState.data(_items..addAll(result), true);
        } else {
          state = PaginationNotifierState.data(_items..addAll(result), false);
        }
        onGoingState = OnGoingState.Data;
      } catch (e) {
        state = PaginationNotifierState.data(_items, false);
        onGoingState = OnGoingState.Error;
      } finally {}
    }
  }
}

enum OnGoingState {
  Idle,
  Data,
  Loading,
  Error,
}
