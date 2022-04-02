import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../core/notifiers/pagination_notifier.dart';
import '../../models/notification/notification.dart';
import '../../models/pagination_state/pagination_notifier_state.dart';

typedef ChaseAppNotificationStateNotifierProvider
    = AutoDisposeStateNotifierProviderFamily<
        PaginationNotifier<ChaseAppNotification>,
        PaginationNotifierState<ChaseAppNotification>,
        Logger>;

typedef ChaseAppNotificationStateNotifierProviderRef
    = AutoDisposeStateNotifierProviderRef<
        PaginationNotifier<ChaseAppNotification>,
        PaginationNotifierState<ChaseAppNotification>>;
