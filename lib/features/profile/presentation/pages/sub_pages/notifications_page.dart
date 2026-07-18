import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../../core/widgets/custom_card.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<dynamic> _notifications = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      final result = await ApiService.getNotifications(authState.email);
      if (mounted) {
        setState(() {
          if (result['success']) {
            _notifications = result['data'];
          } else {
            _error = result['message'];
          }
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
        : _error != null 
          ? Center(child: Text(_error!))
          : _notifications.isEmpty
            ? const Center(child: Text('لا توجد إشعارات حالياً'))
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CustomCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.notifications_active, color: AppColors.primaryGreen),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  notification['title'] ?? 'إشعار جديد',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  notification['message'] ?? '',
                                  style: const TextStyle(color: AppColors.textSecondary),
                                  textAlign: TextAlign.right,
                                ),
                                Text(
                                  notification['date'] ?? '',
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
