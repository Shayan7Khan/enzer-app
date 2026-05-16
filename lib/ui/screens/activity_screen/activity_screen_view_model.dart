import 'package:enzer_app/core/enums/view_state.dart';
import 'package:enzer_app/core/models/notification_items.dart';
import 'package:enzer_app/core/others/base_view_model.dart';
import 'package:enzer_app/core/services/auth_service.dart';
import 'package:enzer_app/locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ActivityViewModel extends BaseViewModel {
  final _supabase = Supabase.instance.client;
  final _auth = locator<AuthService>();

  List<NotificationItem> notifications = [];
  Map<String, List<NotificationItem>> groupedNotifications = {};
  bool isRefreshing = false;

  RealtimeChannel? _channel;

  ActivityViewModel() {
    fetchNotifications();
    _subscribeToNotifications();
  }

  void _subscribeToNotifications() {
    final userId = _auth.userProfile?.id;
    if (userId == null) return;

    _channel = _supabase
        .channel('notifications:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (_) async {
            isRefreshing = true;
            notifyListeners();
            await fetchNotifications();
            isRefreshing = false;
            notifyListeners();
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (_) async {
            isRefreshing = true;
            notifyListeners();
            await fetchNotifications();
            isRefreshing = false;
            notifyListeners();
          },
        )
        .subscribe();
  }

  Future<void> fetchNotifications() async {
    try {
      setState(ViewState.busy);
      final userId = _auth.userProfile?.id;
      if (userId == null) return;

      final data = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      notifications = (data as List)
          .map((e) => NotificationItem.fromMap(e))
          .toList();

      _groupNotifications();
      notifyListeners();

      await _markAllAsReadInDb(userId);
    } catch (e) {
      // handle
    } finally {
      setState(ViewState.idle);
    }
  }

  Future<void> _markAllAsReadInDb(String userId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', userId)
          .eq('is_read', false);

      notifications = notifications
          .map(
            (n) => NotificationItem(
              id: n.id,
              title: n.title,
              body: n.body,
              isRead: true,
              createdAt: n.createdAt,
              type: n.type,
            ),
          )
          .toList();

      _groupNotifications();
      notifyListeners();
    } catch (e) {
      // handle
    }
  }

  void _groupNotifications() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final Map<String, List<NotificationItem>> grouped = {
      'Today': [],
      'Older': [],
    };

    for (final n in notifications) {
      final date = DateTime(
        n.createdAt.year,
        n.createdAt.month,
        n.createdAt.day,
      );
      if (date == today) {
        grouped['Today']!.add(n);
      } else {
        grouped['Older']!.add(n);
      }
    }

    grouped.removeWhere((key, value) => value.isEmpty);
    groupedNotifications = grouped;
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  String formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} h ago';
    if (diff.inDays == 1) return '1 day ago';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} week ago';
    return '${(diff.inDays / 30).floor()} month ago';
  }

  @override
  void dispose() {
    if (_channel != null) {
      _supabase.removeChannel(_channel!);
    }
    super.dispose();
  }
}
