import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../models/pagination_state/pagination_notifier_state.dart';

class PaginationNotifier<T> extends StateNotifier<PaginationNotifierState<T>> {
  PaginationNotifier({
    required this.fetchNextItems,
    required this.hitsPerPage,
    required this.logger,
  }) : super(const PaginationNotifierState.loading([])) {
    init();
  }

  final Logger logger;
  final Future<List<T>> Function(T? item, int offset) fetchNextItems;
  final int hitsPerPage;

  final List<T> _items = [];

  Timer _timer = Timer(const Duration(), () {});

  bool noMoreItems = false;

  void init() {
    if (_items.isEmpty) {
      // _timer.cancel();
      fetchFirstPage(true);
    }
  }

  void updateData(List<T> result) {
    noMoreItems = result.length < hitsPerPage;

    if (!mounted) {
      log('PaginationNotifier not mounted');
      return;
    }

    if (result.isEmpty) {
      state = PaginationNotifierState.data(_items);
    } else {
      state = PaginationNotifierState.data(_items..addAll(result));
    }
  }

  Future<void> fetchFirstPage(bool clearCurrentList) async {
    if (!mounted) {
      log('FetchNextPage called on unmounted PaginationNotifier');
      return;
    }
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
      updateData(result);
    } catch (e, stk) {
      logger.warning('Error fetching First page', e, stk);
      state = PaginationNotifierState.error(e, stk);
    }
  }

  Future<void> fetchNextPage({
    bool clearCurrentList = false,
  }) async {
    if (_timer.isActive && _items.isNotEmpty) {
      return;
    }
    _timer = Timer(const Duration(milliseconds: 1000), () {});

    if (!mounted) {
      log('FetchNextPage called on unmounted PaginationNotifier');
      return;
    }

    if (noMoreItems ||
        state == PaginationNotifierState<T>.onGoingLoading(_items)) {
      log('Rejected');
      return;
    }

    log('Passed');

    state = PaginationNotifierState.onGoingLoading(_items);

    try {
      await Future<void>.delayed(const Duration(seconds: 1));
      final List<T> result = await fetchNextItems(_items.last, _items.length);
      updateData(result);
    } catch (e, stk) {
      logger.warning('Error fetching next page', e, stk);
      state = PaginationNotifierState.onGoingError(_items, e, stk);
    }
  }
}
