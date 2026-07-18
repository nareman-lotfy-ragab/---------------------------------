// // import 'package:flutter/material.dart';
// // import '../../../../core/theme/app_colors.dart';
// // import '../../../../core/services/api_service.dart'; // عدلي المسار حسب مكان الملف

// // class AIChatPage extends StatefulWidget {
// //   const AIChatPage({super.key});

// //   @override
// //   State<AIChatPage> createState() => _AIChatPageState();
// // }

// // class _AIChatPageState extends State<AIChatPage> {
// //   final _messageController = TextEditingController();
// //   final ScrollController _scrollController = ScrollController();

// //   bool _isLoading = false;

// //   final List<Map<String, dynamic>> _messages = [
// //     {
// //       'text':
// //           '🌱 أهلاً بك في AgriSense، كيف يمكنني مساعدتك في أمور الزراعة اليوم؟',
// //       'isUser': false,
// //       'time': '10:00 AM',
// //     },
// //   ];

// //   String _currentTime() {
// //     final now = TimeOfDay.now();
// //     final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
// //     final minute = now.minute.toString().padLeft(2, '0');
// //     final period = now.period == DayPeriod.am ? 'AM' : 'PM';

// //     return '$hour:$minute $period';
// //   }

// // void _scrollToBottom() {
// //   Future.delayed(const Duration(milliseconds: 100), () {
// //     if (_scrollController.hasClients) {
// //       _scrollController.animateTo(
// //         _scrollController.position.maxScrollExtent,
// //         duration: const Duration(milliseconds: 300),
// //         curve: Curves.easeOut,
// //       );
// //     }
// //   });
// // }

// //   Future<void> _sendMessage() async {
// //     if (_messageController.text.trim().isEmpty || _isLoading) return;

// //     final question = _messageController.text.trim();
    
// //     _messageController.clear();

// //     setState(() {
// //   _messages.add({
// //     'text': question,
// //     'isUser': true,
// //     'time': _currentTime(),
// //   });

// //   _isLoading = true;
// // });

// // _scrollToBottom();
// //     try {
// //       final answer = await RagService.askQuestion(
// //         projectId: 1, // غيريها لو الـ project_id مختلف
// //         question: question,
// //       );

// //       if (!mounted) return;

// //       setState(() {
// //   _messages.add({
// //     'text': answer,
// //     'isUser': false,
// //     'time': _currentTime(),
// //   });

// //   _isLoading = false;
// // });

// // _scrollToBottom();
// //     } catch (e) {
// //   if (!mounted) return;

// //   setState(() {
// //     _messages.add({
// //       'text': 'Error: $e',
// //       'isUser': false,
// //       'time': _currentTime(),
// //     });

// //     _isLoading = false;
// //   });

// //   _scrollToBottom();
// // }}

// //   @override
// // void dispose() {
// //   _messageController.dispose();
// //   _scrollController.dispose();
// //   super.dispose();
// // }
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           'AI Chat Assistant',
// //           style: TextStyle(fontWeight: FontWeight.bold),
// //         ),
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         actions: [
// //           IconButton(
// //             icon: const Icon(
// //               Icons.more_vert,
// //               color: AppColors.textPrimary,
// //             ),
// //             onPressed: () {},
// //           ),
// //         ],
// //       ),
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             Expanded(
// //               child: ListView.builder(
// //                 controller: _scrollController,
// //                 padding: const EdgeInsets.all(24),
// //                 itemCount: _messages.length + (_isLoading ? 1 : 0),
// //                 itemBuilder: (context, index) {
// //                   if (_isLoading && index == _messages.length) {
// //                     return const Padding(
// //                       padding: EdgeInsets.only(bottom: 24),
// //                       child: Row(
// //                         children: [
// //                           SizedBox(
// //                             width: 22,
// //                             height: 22,
// //                             child: CircularProgressIndicator(
// //                               strokeWidth: 2,
// //                             ),
// //                           ),
// //                           SizedBox(width: 12),
// //                           Text(
// //                             "Thinking...",
// //                             style: TextStyle(
// //                               color: AppColors.textSecondary,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     );
// //                   }

// //                   final message = _messages[index];

// //                   return _ChatBubble(
// //                     text: message['text'],
// //                     isUser: message['isUser'],
// //                     time: message['time'],
// //                   );
// //                 },
// //               ),
// //             ),
// //             _buildInputArea(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildInputArea() {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 10,
// //             offset: const Offset(0, -4),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           Expanded(
// //             child: TextField(
// //                 controller: _messageController,
// //                 onSubmitted: (_) => _sendMessage(),
// //                 textInputAction: TextInputAction.newline,
// //                 minLines: 1,
// //                 maxLines: 5,
// //                 decoration: InputDecoration(
// //                   hintText: 'Type your message...',
// //                   hintStyle: const TextStyle(
// //                     color: AppColors.textSecondary,
// //                   ),
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(24),
// //                     borderSide: BorderSide.none,
// //                   ),
// //                   filled: true,
// //                   fillColor: AppColors.backgroundLight,
// //                   contentPadding: const EdgeInsets.symmetric(
// //                     horizontal: 20,
// //                     vertical: 12,
// //                   ),
// //                 ),
// //               )
// //           ),
// //           const SizedBox(width: 12),
// //           GestureDetector(
// //   onTap: _isLoading ? null : _sendMessage,
// //   child: Container(
// //     decoration: BoxDecoration(
// //       color: _isLoading
// //           ? Colors.grey
// //           : AppColors.primaryGreen,
// //       shape: BoxShape.circle,
// //     ),
// //     padding: const EdgeInsets.all(12),
// //     child: const Icon(
// //       Icons.send,
// //       color: Colors.white,
// //       size: 24,
// //     ),
// //   ),
// // )
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _ChatBubble extends StatelessWidget {
// //   final String text;
// //   final bool isUser;
// //   final String time;

// //   const _ChatBubble({
// //     required this.text,
// //     required this.isUser,
// //     required this.time,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 24),
// //       child: Column(
// //         crossAxisAlignment:
// //             isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.all(16),
// //             constraints: BoxConstraints(
// //               maxWidth:
// //                   MediaQuery.of(context).size.width * 0.75,
// //             ),
// //             decoration: BoxDecoration(
// //               color: isUser
// //                   ? AppColors.primaryGreen
// //                   : AppColors.surfaceLight,
// //               borderRadius: BorderRadius.only(
// //                 topLeft: const Radius.circular(16),
// //                 topRight: const Radius.circular(16),
// //                 bottomLeft:
// //                     Radius.circular(isUser ? 16 : 0),
// //                 bottomRight:
// //                     Radius.circular(isUser ? 0 : 16),
// //               ),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.05),
// //                   blurRadius: 10,
// //                   offset: const Offset(0, 4),
// //                 ),
// //               ],
// //             ),
// //             child: Text(
// //               text,
// //               style: TextStyle(
// //                 color: isUser
// //                     ? Colors.white
// //                     : AppColors.textPrimary,
// //                 fontSize: 15,
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 4),
// //           Text(
// //             time,
// //             style: const TextStyle(
// //               fontSize: 11,
// //               color: AppColors.textSecondary,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }


// // import 'package:flutter/material.dart';
// // import '../../../../core/theme/app_colors.dart';
// // import '../../../../core/services/api_service.dart';

// // class AIChatPage extends StatefulWidget {
// //   const AIChatPage({super.key});

// //   @override
// //   State<AIChatPage> createState() => _AIChatPageState();
// // }

// // class _AIChatPageState extends State<AIChatPage> {
// //   final _messageController = TextEditingController();
// //   final ScrollController _scrollController = ScrollController();

// //   bool _isLoading = false;

// //   final List<Map<String, dynamic>> _messages = [
// //     {
// //       'text':
// //           '🌱 أهلاً بك في AgriSense AI! أنا هنا لمساعدتك في كل أسئلتك الزراعية. اسأل عن أي شيء يتعلق بالمحاصيل والأمراض والتوصيات الزراعية.',
// //       'isUser': false,
// //       'time': '10:00 AM',
// //       'type': 'greeting',
// //     },
// //   ];

// //   String _currentTime() {
// //     final now = TimeOfDay.now();
// //     final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
// //     final minute = now.minute.toString().padLeft(2, '0');
// //     final period = now.period == DayPeriod.am ? 'AM' : 'PM';

// //     return '$hour:$minute $period';
// //   }

// //   void _scrollToBottom() {
// //     Future.delayed(const Duration(milliseconds: 100), () {
// //       if (_scrollController.hasClients) {
// //         _scrollController.animateTo(
// //           _scrollController.position.maxScrollExtent,
// //           duration: const Duration(milliseconds: 300),
// //           curve: Curves.easeOut,
// //         );
// //       }
// //     });
// //   }

// //   Future<void> _sendMessage() async {
// //     if (_messageController.text.trim().isEmpty || _isLoading) return;

// //     final question = _messageController.text.trim();

// //     _messageController.clear();

// //     setState(() {
// //       _messages.add({
// //         'text': question,
// //         'isUser': true,
// //         'time': _currentTime(),
// //         'type': 'user',
// //       });

// //       _isLoading = true;
// //     });

// //     _scrollToBottom();
// //     try {
// //       final answer = await RagService.askQuestion(
// //         projectId: 1,
// //         question: question,
// //       );

// //       if (!mounted) return;

// //       setState(() {
// //         _messages.add({
// //           'text': answer,
// //           'isUser': false,
// //           'time': _currentTime(),
// //           'type': 'response',
// //         });

// //         _isLoading = false;
// //       });

// //       _scrollToBottom();
// //     } catch (e) {
// //       if (!mounted) return;

// //       setState(() {
// //         _messages.add({
// //           'text': '❌ عذراً، حدث خطأ في الاتصال. تأكد من اتصالك بالإنترنت وحاول مرة أخرى.',
// //           'isUser': false,
// //           'time': _currentTime(),
// //           'type': 'error',
// //         });

// //         _isLoading = false;
// //       });

// //       _scrollToBottom();
// //     }
// //   }

// //   void _clearChat() {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text('مسح المحادثة'),
// //         content: const Text('هل تريد مسح جميع الرسائل؟'),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text('إلغاء'),
// //           ),
// //           TextButton(
// //             onPressed: () {
// //               setState(() {
// //                 _messages.clear();
// //                 _messages.add({
// //                   'text':
// //                       '🌱 أهلاً بك في AgriSense AI! أنا هنا لمساعدتك في كل أسئلتك الزراعية.',
// //                   'isUser': false,
// //                   'time': _currentTime(),
// //                   'type': 'greeting',
// //                 });
// //               });
// //               Navigator.pop(context);
// //             },
// //             child: const Text('مسح'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _messageController.dispose();
// //     _scrollController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Row(
// //           children: [
// //             Icon(Icons.agriculture, color: AppColors.primaryGreen),
// //             SizedBox(width: 8),
// //             Text(
// //               'AgriSense AI Chat',
// //               style: TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: 18,
// //                 color: AppColors.textPrimary,
// //               ),
// //             ),
// //           ],
// //         ),
// //         backgroundColor: Colors.white,
// //         elevation: 2,
// //         shadowColor: Colors.black.withOpacity(0.1),
// //         actions: [
// //           IconButton(
// //             icon: const Icon(
// //               Icons.delete_sweep,
// //               color: AppColors.primaryGreen,
// //             ),
// //             onPressed: _clearChat,
// //             tooltip: 'مسح المحادثة',
// //           ),
// //           IconButton(
// //             icon: const Icon(
// //               Icons.info_outline,
// //               color: AppColors.primaryGreen,
// //             ),
// //             onPressed: () {
// //               showDialog(
// //                 context: context,
// //                 builder: (context) => AlertDialog(
// //                   title: const Text('عن AgriSense AI'),
// //                   content: const Text(
// //                     'AgriSense AI هو مساعد ذكي متخصص في الزراعة. يمكنه الإجابة على أسئلتك حول:\n\n'
// //                     '• المحاصيل والنباتات\n'
// //                     '• الأمراض والآفات\n'
// //                     '• التوصيات الزراعية\n'
// //                     '• أفضل الممارسات الزراعية',
// //                   ),
// //                   actions: [
// //                     TextButton(
// //                       onPressed: () => Navigator.pop(context),
// //                       child: const Text('حسناً'),
// //                     ),
// //                   ],
// //                 ),
// //               );
// //             },
// //             tooltip: 'معلومات',
// //           ),
// //         ],
// //       ),
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             Expanded(
// //               child: _messages.isEmpty
// //                   ? Center(
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           Icon(
// //                             Icons.chat_bubble_outline,
// //                             size: 64,
// //                             color: AppColors.primaryGreen.withOpacity(0.3),
// //                           ),
// //                           const SizedBox(height: 16),
// //                           Text(
// //                             'ابدأ محادثة جديدة',
// //                             style: TextStyle(
// //                               fontSize: 18,
// //                               color: AppColors.textSecondary,
// //                               fontWeight: FontWeight.w500,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     )
// //                   : ListView.builder(
// //                       controller: _scrollController,
// //                       padding: const EdgeInsets.all(16),
// //                       itemCount: _messages.length + (_isLoading ? 1 : 0),
// //                       itemBuilder: (context, index) {
// //                         if (_isLoading && index == _messages.length) {
// //                           return Padding(
// //                             padding: const EdgeInsets.only(bottom: 16),
// //                             child: Row(
// //                               children: [
// //                                 Container(
// //                                   width: 32,
// //                                   height: 32,
// //                                   decoration: BoxDecoration(
// //                                     color: AppColors.primaryGreen.withOpacity(0.1),
// //                                     shape: BoxShape.circle,
// //                                   ),
// //                                   child: const Padding(
// //                                     padding: EdgeInsets.all(4),
// //                                     child: CircularProgressIndicator(
// //                                       strokeWidth: 2,
// //                                       valueColor: AlwaysStoppedAnimation<Color>(
// //                                         AppColors.primaryGreen,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 const SizedBox(width: 12),
// //                                 Text(
// //                                   "جاري التفكير...",
// //                                   style: TextStyle(
// //                                     color: AppColors.textSecondary,
// //                                     fontStyle: FontStyle.italic,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           );
// //                         }

// //                         final message = _messages[index];

// //                         return _ChatBubble(
// //                           text: message['text'],
// //                           isUser: message['isUser'],
// //                           time: message['time'],
// //                           type: message['type'] ?? 'normal',
// //                         );
// //                       },
// //                     ),
// //             ),
// //             _buildInputArea(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildInputArea() {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.08),
// //             blurRadius: 12,
// //             offset: const Offset(0, -4),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           Expanded(
// //             child: TextField(
// //               controller: _messageController,
// //               onSubmitted: (_) => _sendMessage(),
// //               textInputAction: TextInputAction.send,
// //               minLines: 1,
// //               maxLines: 4,
// //               decoration: InputDecoration(
// //                 hintText: 'اسأل عن أي شيء زراعي...',
// //                 hintStyle: const TextStyle(
// //                   color: AppColors.textSecondary,
// //                 ),
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(24),
// //                   borderSide: const BorderSide(
// //                     color: AppColors.primaryGreen,
// //                     width: 1,
// //                   ),
// //                 ),
// //                 enabledBorder: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(24),
// //                   borderSide: BorderSide(
// //                     color: AppColors.primaryGreen.withOpacity(0.3),
// //                     width: 1,
// //                   ),
// //                 ),
// //                 focusedBorder: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(24),
// //                   borderSide: const BorderSide(
// //                     color: AppColors.primaryGreen,
// //                     width: 2,
// //                   ),
// //                 ),
// //                 filled: true,
// //                 fillColor: AppColors.backgroundLight,
// //                 contentPadding: const EdgeInsets.symmetric(
// //                   horizontal: 20,
// //                   vertical: 12,
// //                 ),
// //                 prefixIcon: const Padding(
// //                   padding: EdgeInsets.only(left: 16),
// //                   child: Icon(
// //                     Icons.agriculture,
// //                     color: AppColors.primaryGreen,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //           GestureDetector(
// //             onTap: _isLoading ? null : _sendMessage,
// //             child: Container(
// //               decoration: BoxDecoration(
// //                 color: _isLoading
// //                     ? AppColors.primaryGreen.withOpacity(0.5)
// //                     : AppColors.primaryGreen,
// //                 shape: BoxShape.circle,
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: AppColors.primaryGreen.withOpacity(0.3),
// //                     blurRadius: 8,
// //                     offset: const Offset(0, 4),
// //                   ),
// //                 ],
// //               ),
// //               padding: const EdgeInsets.all(12),
// //               child: Icon(
// //                 _isLoading ? Icons.hourglass_empty : Icons.send,
// //                 color: Colors.white,
// //                 size: 24,
// //               ),
// //             ),
// //           )
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _ChatBubble extends StatelessWidget {
// //   final String text;
// //   final bool isUser;
// //   final String time;
// //   final String type;

// //   const _ChatBubble({
// //     required this.text,
// //     required this.isUser,
// //     required this.time,
// //     this.type = 'normal',
// //   });

// //   Color _getBubbleColor() {
// //     if (isUser) {
// //       return AppColors.primaryGreen;
// //     }
    
// //     switch (type) {
// //       case 'error':
// //         return Colors.red.withOpacity(0.1);
// //       case 'greeting':
// //         return AppColors.primaryGreen.withOpacity(0.1);
// //       default:
// //         return AppColors.surfaceLight;
// //     }
// //   }

// //   Color _getTextColor() {
// //     if (isUser) {
// //       return Colors.white;
// //     }
    
// //     switch (type) {
// //       case 'error':
// //         return Colors.red;
// //       default:
// //         return AppColors.textPrimary;
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 16),
// //       child: Column(
// //         crossAxisAlignment:
// //             isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.all(14),
// //             constraints: BoxConstraints(
// //               maxWidth: MediaQuery.of(context).size.width * 0.8,
// //             ),
// //             decoration: BoxDecoration(
// //               color: _getBubbleColor(),
// //               borderRadius: BorderRadius.only(
// //                 topLeft: const Radius.circular(18),
// //                 topRight: const Radius.circular(18),
// //                 bottomLeft: Radius.circular(isUser ? 18 : 4),
// //                 bottomRight: Radius.circular(isUser ? 4 : 18),
// //               ),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.06),
// //                   blurRadius: 8,
// //                   offset: const Offset(0, 2),
// //                 ),
// //               ],
// //             ),
// //             child: Text(
// //               text,
// //               style: TextStyle(
// //                 color: _getTextColor(),
// //                 fontSize: 15,
// //                 height: 1.4,
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 6),
// //           Text(
// //             time,
// //             style: const TextStyle(
// //               fontSize: 12,
// //               color: AppColors.textSecondary,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/services/api_service.dart';
// import '../../data/models/chat_models.dart';
// import '../../data/datasources/chat_storage_service.dart';

// class AIChatPage extends StatefulWidget {
//   const AIChatPage({super.key});

//   @override
//   State<AIChatPage> createState() => _AIChatPageState();
// }

// class _AIChatPageState extends State<AIChatPage> {
//   final _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   bool _isLoading = false;
//   String? _currentSessionId;
//   List<ChatSession> _allSessions = [];
//   bool _showHistory = false;

//   final List<ChatMessage> _currentMessages = [
//     ChatMessage(
//       text: '🌱 أهلاً بك في AgriSense AI! أنا هنا لمساعدتك في كل أسئلتك الزراعية. اسأل عن أي شيء يتعلق بالمحاصيل والأمراض والتوصيات الزراعية.',
//       isUser: false,
//       time: _getCurrentTime(),
//       type: 'greeting',
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _initializeChat();
//   }

//   Future<void> _initializeChat() async {
//     final sessions = await ChatStorageService.getSessions();
//     setState(() {
//       _allSessions = sessions;
//       if (sessions.isNotEmpty) {
//         _currentSessionId = sessions.first.id;
//         _currentMessages.clear();
//         _currentMessages.addAll(sessions.first.messages);
//       } else {
//         _currentSessionId = const Uuid().v4();
//         _createNewSession();
//       }
//     });
//   }

//   static String _getCurrentTime() {
//     final now = TimeOfDay.now();
//     final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
//     final minute = now.minute.toString().padLeft(2, '0');
//     final period = now.period == DayPeriod.am ? 'AM' : 'PM';
//     return '$hour:$minute $period';
//   }

//   Future<void> _createNewSession() async {
//     final sessionId = const Uuid().v4();
//     final session = ChatSession(
//       id: sessionId,
//       title: 'محادثة جديدة',
//       createdAt: DateTime.now(),
//       messages: _currentMessages,
//     );

//     await ChatStorageService.saveSession(session);
//     setState(() {
//       _currentSessionId = sessionId;
//       _allSessions.insert(0, session);
//     });
//   }

//   Future<void> _saveCurrentSession() async {
//     if (_currentSessionId == null) return;

//     final session = ChatSession(
//       id: _currentSessionId!,
//       title: _generateSessionTitle(),
//       createdAt: DateTime.now(),
//       messages: _currentMessages,
//     );

//     await ChatStorageService.saveSession(session);

//     final index = _allSessions.indexWhere((s) => s.id == _currentSessionId);
//     if (index != -1) {
//       setState(() {
//         _allSessions[index] = session;
//       });
//     }
//   }

//   String _generateSessionTitle() {
//     if (_currentMessages.length > 1) {
//       final firstUserMessage = _currentMessages.firstWhere(
//         (msg) => msg.isUser,
//         orElse: () => ChatMessage(
//           text: 'محادثة جديدة',
//           isUser: false,
//           time: _getCurrentTime(),
//         ),
//       );
//       return firstUserMessage.text.length > 30
//           ? '${firstUserMessage.text.substring(0, 30)}...'
//           : firstUserMessage.text;
//     }
//     return 'محادثة جديدة';
//   }

//   void _loadSession(ChatSession session) {
//     setState(() {
//       _currentSessionId = session.id;
//       _currentMessages.clear();
//       _currentMessages.addAll(session.messages);
//       _showHistory = false;
//     });
//   }

//   Future<void> _deleteSession(String id) async {
//     await ChatStorageService.deleteSession(id);
//     setState(() {
//       _allSessions.removeWhere((s) => s.id == id);
//     });

//     if (_currentSessionId == id) {
//       if (_allSessions.isNotEmpty) {
//         _loadSession(_allSessions.first);
//       } else {
//         _currentMessages.clear();
//         _currentMessages.add(
//           ChatMessage(
//             text: '🌱 أهلاً بك في AgriSense AI! أنا هنا لمساعدتك في كل أسئلتك الزراعية.',
//             isUser: false,
//             time: _getCurrentTime(),
//             type: 'greeting',
//           ),
//         );
//         await _createNewSession();
//       }
//     }
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   Future<void> _sendMessage() async {
//     if (_messageController.text.trim().isEmpty || _isLoading) return;

//     final question = _messageController.text.trim();
//     _messageController.clear();

//     setState(() {
//       _currentMessages.add(
//         ChatMessage(
//           text: question,
//           isUser: true,
//           time: _getCurrentTime(),
//           type: 'user',
//         ),
//       );
//       _isLoading = true;
//     });

//     _scrollToBottom();

//     try {
//       final answer = await RagService.askQuestion(
//         projectId: 1,
//         question: question,
//         sessionId: _currentSessionId,
//       );

//       if (!mounted) return;

//       setState(() {
//         _currentMessages.add(
//           ChatMessage(
//             text: answer,
//             isUser: false,
//             time: _getCurrentTime(),
//             type: 'response',
//           ),
//         );
//         _isLoading = false;
//       });

//       await _saveCurrentSession();
//       _scrollToBottom();
//     } catch (e) {
//       if (!mounted) return;

//       setState(() {
//         _currentMessages.add(
//           ChatMessage(
//             text: '❌ عذراً، حدث خطأ في الاتصال. تأكد من اتصالك بالإنترنت وحاول مرة أخرى.',
//             isUser: false,
//             time: _getCurrentTime(),
//             type: 'error',
//           ),
//         );
//         _isLoading = false;
//       });

//       _scrollToBottom();
//     }
//   }

//   void _clearChat() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('مسح المحادثة'),
//         content: const Text('هل تريد مسح جميع الرسائل في هذه المحادثة؟'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('إلغاء'),
//           ),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 _currentMessages.clear();
//                 _currentMessages.add(
//                   ChatMessage(
//                     text: '🌱 أهلاً بك في AgriSense AI! أنا هنا لمساعدتك في كل أسئلتك الزراعية.',
//                     isUser: false,
//                     time: _getCurrentTime(),
//                     type: 'greeting',
//                   ),
//                 );
//               });
//               Navigator.pop(context);
//             },
//             child: const Text('مسح'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showDeleteConfirmation(String sessionId) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('حذف المحادثة'),
//         content: const Text('هل تريد حذف هذه المحادثة نهائياً؟'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('إلغاء'),
//           ),
//           TextButton(
//             onPressed: () {
//               _deleteSession(sessionId);
//               Navigator.pop(context);
//             },
//             child: const Text('حذف'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.agriculture, color: AppColors.primaryGreen),
//             SizedBox(width: 8),
//             Flexible(
//               child: Text(
//                 'AgriSense AI Chat',
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.white,
//         elevation: 2,
//         shadowColor: Colors.black.withOpacity(0.1),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.history, color: AppColors.primaryGreen),
//             onPressed: () {
//               setState(() {
//                 _showHistory = !_showHistory;
//               });
//             },
//             tooltip: 'سجل المحادثات',
//           ),
//           IconButton(
//             icon: const Icon(Icons.add, color: AppColors.primaryGreen),
//             onPressed: () {
//               setState(() {
//                 _currentMessages.clear();
//                 _currentMessages.add(
//                   ChatMessage(
//                     text: '🌱 أهلاً بك في AgriSense AI! أنا هنا لمساعدتك في كل أسئلتك الزراعية.',
//                     isUser: false,
//                     time: _getCurrentTime(),
//                     type: 'greeting',
//                   ),
//                 );
//               });
//               _createNewSession();
//             },
//             tooltip: 'محادثة جديدة',
//           ),
//           IconButton(
//             icon: const Icon(Icons.delete_sweep, color: AppColors.primaryGreen),
//             onPressed: _clearChat,
//             tooltip: 'مسح المحادثة',
//           ),
//           IconButton(
//             icon: const Icon(Icons.info_outline, color: AppColors.primaryGreen),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   title: const Text('عن AgriSense AI'),
//                   content: const Text(
//                     'AgriSense AI هو مساعد ذكي متخصص في الزراعة. يمكنه الإجابة على أسئلتك حول:\n\n'
//                     '• المحاصيل والنباتات\n'
//                     '• الأمراض والآفات\n'
//                     '• التوصيات الزراعية\n'
//                     '• أفضل الممارسات الزراعية\n\n'
//                     'جميع محادثاتك يتم حفظها تلقائياً!',
//                   ),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('حسناً'),
//                     ),
//                   ],
//                 ),
//               );
//             },
//             tooltip: 'معلومات',
//           ),
//         ],
//       ),
//       body: Row(
//         children: [
//           if (_showHistory)
//             _buildHistorySidebar(),
//           Expanded(
//             child: Column(
//               children: [
//                 Expanded(
//                   child: _currentMessages.isEmpty
//                       ? Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.chat_bubble_outline,
//                                 size: 64,
//                                 color: AppColors.primaryGreen.withOpacity(0.3),
//                               ),
//                               const SizedBox(height: 16),
//                               const Text(
//                                 'ابدأ محادثة جديدة',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   color: AppColors.textSecondary,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       : ListView.builder(
//                           controller: _scrollController,
//                           padding: const EdgeInsets.all(16),
//                           itemCount: _currentMessages.length + (_isLoading ? 1 : 0),
//                           itemBuilder: (context, index) {
//                             if (_isLoading && index == _currentMessages.length) {
//                               return Padding(
//                                 padding: const EdgeInsets.only(bottom: 16),
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       width: 32,
//                                       height: 32,
//                                       decoration: BoxDecoration(
//                                         color: AppColors.primaryGreen.withOpacity(0.1),
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: const Padding(
//                                         padding: EdgeInsets.all(4),
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                           valueColor: AlwaysStoppedAnimation<Color>(
//                                             AppColors.primaryGreen,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 12),
//                                     const Text(
//                                       "جاري التفكير...",
//                                       style: TextStyle(
//                                         color: AppColors.textSecondary,
//                                         fontStyle: FontStyle.italic,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }

//                             final message = _currentMessages[index];

//                             return _ChatBubble(
//                               text: message.text,
//                               isUser: message.isUser,
//                               time: message.time,
//                               type: message.type,
//                             );
//                           },
//                         ),
//                 ),
//                 _buildInputArea(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHistorySidebar() {
//     return Container(
//       width: 280,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(
//           right: BorderSide(
//             color: Colors.grey.withOpacity(0.2),
//             width: 1,
//           ),
//         ),
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'السجل',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.close, size: 20),
//                   onPressed: () {
//                     setState(() {
//                       _showHistory = false;
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: _allSessions.isEmpty
//                 ? const Center(
//                     child: Text(
//                       'لا توجد محادثات سابقة',
//                       style: TextStyle(
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//                   )
//                 : ListView.builder(
//                     itemCount: _allSessions.length,
//                     itemBuilder: (context, index) {
//                       final session = _allSessions[index];
//                       final isActive = _currentSessionId == session.id;

//                       return Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: isActive
//                               ? AppColors.primaryGreen.withOpacity(0.1)
//                               : Colors.transparent,
//                           borderRadius: BorderRadius.circular(8),
//                           border: isActive
//                               ? Border.all(
//                                   color: AppColors.primaryGreen,
//                                   width: 1,
//                                 )
//                               : null,
//                         ),
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                           title: Text(
//                             session.title,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontSize: 13,
//                               fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
//                               color: isActive
//                                   ? AppColors.primaryGreen
//                                   : AppColors.textPrimary,
//                             ),
//                           ),
//                           subtitle: Text(
//                             _formatDate(session.createdAt),
//                             style: const TextStyle(fontSize: 11),
//                           ),
//                           onTap: () => _loadSession(session),
//                           trailing: PopupMenuButton(
//                             itemBuilder: (context) => [
//                               PopupMenuItem(
//                                 child: const Row(
//                                   children: [
//                                     Icon(Icons.delete, size: 16),
//                                     SizedBox(width: 8),
//                                     Text('حذف'),
//                                   ],
//                                 ),
//                                 onTap: () => _showDeleteConfirmation(session.id),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final yesterday = today.subtract(const Duration(days: 1));
//     final dateToCheck = DateTime(date.year, date.month, date.day);

//     if (dateToCheck == today) {
//       return 'اليوم ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
//     } else if (dateToCheck == yesterday) {
//       return 'أمس';
//     } else {
//       return '${date.day}/${date.month}/${date.year}';
//     }
//   }

//   Widget _buildInputArea() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 12,
//             offset: const Offset(0, -4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _messageController,
//               onSubmitted: (_) => _sendMessage(),
//               textInputAction: TextInputAction.send,
//               minLines: 1,
//               maxLines: 4,
//               decoration: InputDecoration(
//                 hintText: 'اسأل عن أي شيء زراعي...',
//                 hintStyle: const TextStyle(
//                   color: AppColors.textSecondary,
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(24),
//                   borderSide: const BorderSide(
//                     color: AppColors.primaryGreen,
//                     width: 1,
//                   ),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(24),
//                   borderSide: BorderSide(
//                     color: AppColors.primaryGreen.withOpacity(0.3),
//                     width: 1,
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(24),
//                   borderSide: const BorderSide(
//                     color: AppColors.primaryGreen,
//                     width: 2,
//                   ),
//                 ),
//                 filled: true,
//                 fillColor: AppColors.backgroundLight,
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 12,
//                 ),
//                 prefixIcon: const Padding(
//                   padding: EdgeInsets.only(left: 16),
//                   child: Icon(
//                     Icons.agriculture,
//                     color: AppColors.primaryGreen,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           GestureDetector(
//             onTap: _isLoading ? null : _sendMessage,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: _isLoading
//                     ? AppColors.primaryGreen.withOpacity(0.5)
//                     : AppColors.primaryGreen,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.primaryGreen.withOpacity(0.3),
//                     blurRadius: 8,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.all(12),
//               child: Icon(
//                 _isLoading ? Icons.hourglass_empty : Icons.send,
//                 color: Colors.white,
//                 size: 24,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class _ChatBubble extends StatelessWidget {
//   final String text;
//   final bool isUser;
//   final String time;
//   final String type;

//   const _ChatBubble({
//     required this.text,
//     required this.isUser,
//     required this.time,
//     this.type = 'normal',
//   });

//   Color _getBubbleColor() {
//     if (isUser) {
//       return AppColors.primaryGreen;
//     }

//     switch (type) {
//       case 'error':
//         return Colors.red.withOpacity(0.1);
//       case 'greeting':
//         return AppColors.primaryGreen.withOpacity(0.1);
//       default:
//         return AppColors.surfaceLight;
//     }
//   }

//   Color _getTextColor() {
//     if (isUser) {
//       return Colors.white;
//     }

//     switch (type) {
//       case 'error':
//         return Colors.red;
//       default:
//         return AppColors.textPrimary;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment:
//             isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(14),
//             constraints: BoxConstraints(
//               maxWidth: MediaQuery.of(context).size.width * 0.7,
//             ),
//             decoration: BoxDecoration(
//               color: _getBubbleColor(),
//               borderRadius: BorderRadius.only(
//                 topLeft: const Radius.circular(18),
//                 topRight: const Radius.circular(18),
//                 bottomLeft: Radius.circular(isUser ? 18 : 4),
//                 bottomRight: Radius.circular(isUser ? 4 : 18),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.06),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Text(
//               text,
//               style: TextStyle(
//                 color: _getTextColor(),
//                 fontSize: 15,
//                 height: 1.4,
//               ),
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             time,
//             style: const TextStyle(
//               fontSize: 12,
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/services/api_service.dart'; // عدلي المسار حسب مكان الملف

// class AIChatPage extends StatefulWidget {
//   const AIChatPage({super.key});

//   @override
//   State<AIChatPage> createState() => _AIChatPageState();
// }

// class _AIChatPageState extends State<AIChatPage> {
//   final _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   bool _isLoading = false;

//   final List<Map<String, dynamic>> _messages = [
//     {
//       'text':
//           '🌱 أهلاً بك في AgriSense، كيف يمكنني مساعدتك في أمور الزراعة اليوم؟',
//       'isUser': false,
//       'time': '10:00 AM',
//     },
//   ];

//   String _currentTime() {
//     final now = TimeOfDay.now();
//     final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
//     final minute = now.minute.toString().padLeft(2, '0');
//     final period = now.period == DayPeriod.am ? 'AM' : 'PM';

//     return '$hour:$minute $period';
//   }

// void _scrollToBottom() {
//   Future.delayed(const Duration(milliseconds: 100), () {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   });
// }

//   Future<void> _sendMessage() async {
//     if (_messageController.text.trim().isEmpty || _isLoading) return;

//     final question = _messageController.text.trim();
    
//     _messageController.clear();

//     setState(() {
//   _messages.add({
//     'text': question,
//     'isUser': true,
//     'time': _currentTime(),
//   });

//   _isLoading = true;
// });

// _scrollToBottom();
//     try {
//       final answer = await RagService.askQuestion(
//         projectId: 1, // غيريها لو الـ project_id مختلف
//         question: question,
//       );

//       if (!mounted) return;

//       setState(() {
//   _messages.add({
//     'text': answer,
//     'isUser': false,
//     'time': _currentTime(),
//   });

//   _isLoading = false;
// });

// _scrollToBottom();
//     } catch (e) {
//   if (!mounted) return;

//   setState(() {
//     _messages.add({
//       'text': 'Error: $e',
//       'isUser': false,
//       'time': _currentTime(),
//     });

//     _isLoading = false;
//   });

//   _scrollToBottom();
// }}

//   @override
// void dispose() {
//   _messageController.dispose();
//   _scrollController.dispose();
//   super.dispose();
// }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'AI Chat Assistant',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(
//               Icons.more_vert,
//               color: AppColors.textPrimary,
//             ),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 controller: _scrollController,
//                 padding: const EdgeInsets.all(24),
//                 itemCount: _messages.length + (_isLoading ? 1 : 0),
//                 itemBuilder: (context, index) {
//                   if (_isLoading && index == _messages.length) {
//                     return const Padding(
//                       padding: EdgeInsets.only(bottom: 24),
//                       child: Row(
//                         children: [
//                           SizedBox(
//                             width: 22,
//                             height: 22,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                             ),
//                           ),
//                           SizedBox(width: 12),
//                           Text(
//                             "Thinking...",
//                             style: TextStyle(
//                               color: AppColors.textSecondary,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }

//                   final message = _messages[index];

//                   return _ChatBubble(
//                     text: message['text'],
//                     isUser: message['isUser'],
//                     time: message['time'],
//                   );
//                 },
//               ),
//             ),
//             _buildInputArea(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInputArea() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, -4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//                 controller: _messageController,
//                 onSubmitted: (_) => _sendMessage(),
//                 textInputAction: TextInputAction.newline,
//                 minLines: 1,
//                 maxLines: 5,
//                 decoration: InputDecoration(
//                   hintText: 'Type your message...',
//                   hintStyle: const TextStyle(
//                     color: AppColors.textSecondary,
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(24),
//                     borderSide: BorderSide.none,
//                   ),
//                   filled: true,
//                   fillColor: AppColors.backgroundLight,
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 12,
//                   ),
//                 ),
//               )
//           ),
//           const SizedBox(width: 12),
//           GestureDetector(
//   onTap: _isLoading ? null : _sendMessage,
//   child: Container(
//     decoration: BoxDecoration(
//       color: _isLoading
//           ? Colors.grey
//           : AppColors.primaryGreen,
//       shape: BoxShape.circle,
//     ),
//     padding: const EdgeInsets.all(12),
//     child: const Icon(
//       Icons.send,
//       color: Colors.white,
//       size: 24,
//     ),
//   ),
// )
//         ],
//       ),
//     );
//   }
// }

// class _ChatBubble extends StatelessWidget {
//   final String text;
//   final bool isUser;
//   final String time;

//   const _ChatBubble({
//     required this.text,
//     required this.isUser,
//     required this.time,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 24),
//       child: Column(
//         crossAxisAlignment:
//             isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16),
//             constraints: BoxConstraints(
//               maxWidth:
//                   MediaQuery.of(context).size.width * 0.75,
//             ),
//             decoration: BoxDecoration(
//               color: isUser
//                   ? AppColors.primaryGreen
//                   : AppColors.surfaceLight,
//               borderRadius: BorderRadius.only(
//                 topLeft: const Radius.circular(16),
//                 topRight: const Radius.circular(16),
//                 bottomLeft:
//                     Radius.circular(isUser ? 16 : 0),
//                 bottomRight:
//                     Radius.circular(isUser ? 0 : 16),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Text(
//               text,
//               style: TextStyle(
//                 color: isUser
//                     ? Colors.white
//                     : AppColors.textPrimary,
//                 fontSize: 15,
//               ),
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             time,
//             style: const TextStyle(
//               fontSize: 11,
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/services/api_service.dart';

// class AIChatPage extends StatefulWidget {
//   const AIChatPage({super.key});

//   @override
//   State<AIChatPage> createState() => _AIChatPageState();
// }

// class _AIChatPageState extends State<AIChatPage> {
//   final _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   bool _isLoading = false;

//   final List<Map<String, dynamic>> _messages = [
//     {
//       'text':
//           '🌱 أهلاً بك في AgriSense AI! أنا هنا لمساعدتك في كل أسئلتك الزراعية. اسأل عن أي شيء يتعلق بالمحاصيل والأمراض والتوصيات الزراعية.',
//       'isUser': false,
//       'time': '10:00 AM',
//       'type': 'greeting',
//     },
//   ];

//   String _currentTime() {
//     final now = TimeOfDay.now();
//     final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
//     final minute = now.minute.toString().padLeft(2, '0');
//     final period = now.period == DayPeriod.am ? 'AM' : 'PM';

//     return '$hour:$minute $period';
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   Future<void> _sendMessage() async {
//     if (_messageController.text.trim().isEmpty || _isLoading) return;

//     final question = _messageController.text.trim();

//     _messageController.clear();

//     setState(() {
//       _messages.add({
//         'text': question,
//         'isUser': true,
//         'time': _currentTime(),
//         'type': 'user',
//       });

//       _isLoading = true;
//     });

//     _scrollToBottom();
//     try {
//       final answer = await RagService.askQuestion(
//         projectId: 1,
//         question: question,
//       );

//       if (!mounted) return;

//       setState(() {
//         _messages.add({
//           'text': answer,
//           'isUser': false,
//           'time': _currentTime(),
//           'type': 'response',
//         });

//         _isLoading = false;
//       });

//       _scrollToBottom();
//     } catch (e) {
//       if (!mounted) return;

//       setState(() {
//         _messages.add({
//           'text': '❌ عذراً، حدث خطأ في الاتصال. تأكد من اتصالك بالإنترنت وحاول مرة أخرى.',
//           'isUser': false,
//           'time': _currentTime(),
//           'type': 'error',
//         });

//         _isLoading = false;
//       });

//       _scrollToBottom();
//     }
//   }

//   void _clearChat() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('مسح المحادثة'),
//         content: const Text('هل تريد مسح جميع الرسائل؟'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('إلغاء'),
//           ),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 _messages.clear();
//                 _messages.add({
//                   'text':
//                       '🌱 أهلاً بك في AgriSense AI! أنا هنا لمساعدتك في كل أسئلتك الزراعية.',
//                   'isUser': false,
//                   'time': _currentTime(),
//                   'type': 'greeting',
//                 });
//               });
//               Navigator.pop(context);
//             },
//             child: const Text('مسح'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Row(
//           children: [
//             Icon(Icons.agriculture, color: AppColors.primaryGreen),
//             SizedBox(width: 8),
//             Text(
//               'AgriSense AI Chat',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.white,
//         elevation: 2,
//         shadowColor: Colors.black.withOpacity(0.1),
//         actions: [
//           IconButton(
//             icon: const Icon(
//               Icons.delete_sweep,
//               color: AppColors.primaryGreen,
//             ),
//             onPressed: _clearChat,
//             tooltip: 'مسح المحادثة',
//           ),
//           IconButton(
//             icon: const Icon(
//               Icons.info_outline,
//               color: AppColors.primaryGreen,
//             ),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   title: const Text('عن AgriSense AI'),
//                   content: const Text(
//                     'AgriSense AI هو مساعد ذكي متخصص في الزراعة. يمكنه الإجابة على أسئلتك حول:\n\n'
//                     '• المحاصيل والنباتات\n'
//                     '• الأمراض والآفات\n'
//                     '• التوصيات الزراعية\n'
//                     '• أفضل الممارسات الزراعية',
//                   ),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('حسناً'),
//                     ),
//                   ],
//                 ),
//               );
//             },
//             tooltip: 'معلومات',
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: _messages.isEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.chat_bubble_outline,
//                             size: 64,
//                             color: AppColors.primaryGreen.withOpacity(0.3),
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             'ابدأ محادثة جديدة',
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: AppColors.textSecondary,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   : ListView.builder(
//                       controller: _scrollController,
//                       padding: const EdgeInsets.all(16),
//                       itemCount: _messages.length + (_isLoading ? 1 : 0),
//                       itemBuilder: (context, index) {
//                         if (_isLoading && index == _messages.length) {
//                           return Padding(
//                             padding: const EdgeInsets.only(bottom: 16),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   width: 32,
//                                   height: 32,
//                                   decoration: BoxDecoration(
//                                     color: AppColors.primaryGreen.withOpacity(0.1),
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: const Padding(
//                                     padding: EdgeInsets.all(4),
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       valueColor: AlwaysStoppedAnimation<Color>(
//                                         AppColors.primaryGreen,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Text(
//                                   "جاري التفكير...",
//                                   style: TextStyle(
//                                     color: AppColors.textSecondary,
//                                     fontStyle: FontStyle.italic,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }

//                         final message = _messages[index];

//                         return _ChatBubble(
//                           text: message['text'],
//                           isUser: message['isUser'],
//                           time: message['time'],
//                           type: message['type'] ?? 'normal',
//                         );
//                       },
//                     ),
//             ),
//             _buildInputArea(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInputArea() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 12,
//             offset: const Offset(0, -4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _messageController,
//               onSubmitted: (_) => _sendMessage(),
//               textInputAction: TextInputAction.send,
//               minLines: 1,
//               maxLines: 4,
//               decoration: InputDecoration(
//                 hintText: 'اسأل عن أي شيء زراعي...',
//                 hintStyle: const TextStyle(
//                   color: AppColors.textSecondary,
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(24),
//                   borderSide: const BorderSide(
//                     color: AppColors.primaryGreen,
//                     width: 1,
//                   ),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(24),
//                   borderSide: BorderSide(
//                     color: AppColors.primaryGreen.withOpacity(0.3),
//                     width: 1,
//                   ),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(24),
//                   borderSide: const BorderSide(
//                     color: AppColors.primaryGreen,
//                     width: 2,
//                   ),
//                 ),
//                 filled: true,
//                 fillColor: AppColors.backgroundLight,
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 12,
//                 ),
//                 prefixIcon: const Padding(
//                   padding: EdgeInsets.only(left: 16),
//                   child: Icon(
//                     Icons.agriculture,
//                     color: AppColors.primaryGreen,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           GestureDetector(
//             onTap: _isLoading ? null : _sendMessage,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: _isLoading
//                     ? AppColors.primaryGreen.withOpacity(0.5)
//                     : AppColors.primaryGreen,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.primaryGreen.withOpacity(0.3),
//                     blurRadius: 8,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.all(12),
//               child: Icon(
//                 _isLoading ? Icons.hourglass_empty : Icons.send,
//                 color: Colors.white,
//                 size: 24,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class _ChatBubble extends StatelessWidget {
//   final String text;
//   final bool isUser;
//   final String time;
//   final String type;

//   const _ChatBubble({
//     required this.text,
//     required this.isUser,
//     required this.time,
//     this.type = 'normal',
//   });

//   Color _getBubbleColor() {
//     if (isUser) {
//       return AppColors.primaryGreen;
//     }
    
//     switch (type) {
//       case 'error':
//         return Colors.red.withOpacity(0.1);
//       case 'greeting':
//         return AppColors.primaryGreen.withOpacity(0.1);
//       default:
//         return AppColors.surfaceLight;
//     }
//   }

//   Color _getTextColor() {
//     if (isUser) {
//       return Colors.white;
//     }
    
//     switch (type) {
//       case 'error':
//         return Colors.red;
//       default:
//         return AppColors.textPrimary;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment:
//             isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(14),
//             constraints: BoxConstraints(
//               maxWidth: MediaQuery.of(context).size.width * 0.8,
//             ),
//             decoration: BoxDecoration(
//               color: _getBubbleColor(),
//               borderRadius: BorderRadius.only(
//                 topLeft: const Radius.circular(18),
//                 topRight: const Radius.circular(18),
//                 bottomLeft: Radius.circular(isUser ? 18 : 4),
//                 bottomRight: Radius.circular(isUser ? 4 : 18),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.06),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Text(
//               text,
//               style: TextStyle(
//                 color: _getTextColor(),
//                 fontSize: 15,
//                 height: 1.4,
//               ),
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             time,
//             style: const TextStyle(
//               fontSize: 12,
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../../data/models/chat_models.dart';
import '../../data/datasources/chat_storage_service.dart';

class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  String? _currentSessionId;
  List<ChatSession> _allSessions = [];
  bool _showHistory = false;

  final List<ChatMessage> _currentMessages = [
    ChatMessage(
      text: '🌱 أهلاً بك في AgriSense AI! أنا هنا لمساعدتك في كل أسئلتك الزراعية. اسأل عن أي شيء يتعلق بالمحاصيل والأمراض والتوصيات الزراعية.',
      isUser: false,
      time: _getCurrentTime(),
      type: 'greeting',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    final sessions = await ChatStorageService.getSessions();
    setState(() {
      _allSessions = sessions;
      if (sessions.isNotEmpty) {
        _currentSessionId = sessions.first.id;
        _currentMessages.clear();
        _currentMessages.addAll(sessions.first.messages);
      } else {
        _currentSessionId = const Uuid().v4();
        _createNewSession();
      }
    });
  }

  static String _getCurrentTime() {
    final now = TimeOfDay.now();
    final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _createNewSession() async {
    final sessionId = const Uuid().v4();
    final session = ChatSession(
      id: sessionId,
      title: 'محادثة جديدة',
      createdAt: DateTime.now(),
      messages: _currentMessages,
    );

    await ChatStorageService.saveSession(session);
    setState(() {
      _currentSessionId = sessionId;
      _allSessions.insert(0, session);
    });
  }

  Future<void> _saveCurrentSession() async {
    if (_currentSessionId == null) return;

    final session = ChatSession(
      id: _currentSessionId!,
      title: _generateSessionTitle(),
      createdAt: DateTime.now(),
      messages: _currentMessages,
    );

    await ChatStorageService.saveSession(session);

    final index = _allSessions.indexWhere((s) => s.id == _currentSessionId);
    if (index != -1) {
      setState(() {
        _allSessions[index] = session;
      });
    }
  }

  String _generateSessionTitle() {
    if (_currentMessages.length > 1) {
      final firstUserMessage = _currentMessages.firstWhere(
        (msg) => msg.isUser,
        orElse: () => ChatMessage(
          text: 'محادثة جديدة',
          isUser: false,
          time: _getCurrentTime(),
        ),
      );
      return firstUserMessage.text.length > 30
          ? '${firstUserMessage.text.substring(0, 30)}...'
          : firstUserMessage.text;
    }
    return 'محادثة جديدة';
  }

  void _loadSession(ChatSession session) {
    setState(() {
      _currentSessionId = session.id;
      _currentMessages.clear();
      _currentMessages.addAll(session.messages);
      _showHistory = false;
    });
  }

  Future<void> _deleteSession(String id) async {
    await ChatStorageService.deleteSession(id);
    setState(() {
      _allSessions.removeWhere((s) => s.id == id);
    });

    if (_currentSessionId == id) {
      if (_allSessions.isNotEmpty) {
        _loadSession(_allSessions.first);
      } else {
        _currentMessages.clear();
        _currentMessages.add(
          ChatMessage(
            text: '🌱 أهلاً بك في AgriSense AI! أنا هنا لمساعدتك في كل أسئلتك الزراعية.',
            isUser: false,
            time: _getCurrentTime(),
            type: 'greeting',
          ),
        );
        await _createNewSession();
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _isLoading) return;

    final question = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _currentMessages.add(
        ChatMessage(
          text: question,
          isUser: true,
          time: _getCurrentTime(),
          type: 'user',
        ),
      );
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final answer = await RagService.askQuestion(
        projectId: 1,
        question: question,
        sessionId: _currentSessionId,
      );

      if (!mounted) return;

      setState(() {
        _currentMessages.add(
          ChatMessage(
            text: answer,
            isUser: false,
            time: _getCurrentTime(),
            type: 'response',
          ),
        );
        _isLoading = false;
      });

      await _saveCurrentSession();
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _currentMessages.add(
          ChatMessage(
            text: '❌ عذراً، حدث خطأ في الاتصال. تأكد من اتصالك بالإنترنت وحاول مرة أخرى.',
            isUser: false,
            time: _getCurrentTime(),
            type: 'error',
          ),
        );
        _isLoading = false;
      });

      _scrollToBottom();
    }
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مسح المحادثة'),
        content: const Text('هل تريد مسح جميع الرسائل في هذه المحادثة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _currentMessages.clear();
                _currentMessages.add(
                  ChatMessage(
                    text: '🌱 أهلاً بك في AgriSense AI! أنا هنا لمساعدتك في كل أسئلتك الزراعية.',
                    isUser: false,
                    time: _getCurrentTime(),
                    type: 'greeting',
                  ),
                );
              });
              Navigator.pop(context);
            },
            child: const Text('مسح'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(String sessionId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المحادثة'),
        content: const Text('هل تريد حذف هذه المحادثة نهائياً؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              _deleteSession(sessionId);
              Navigator.pop(context);
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.agriculture, color: AppColors.primaryGreen),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'AgriSense AI Chat',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: AppColors.primaryGreen),
            onPressed: () {
              setState(() {
                _showHistory = !_showHistory;
              });
            },
            tooltip: 'سجل المحادثات',
          ),
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primaryGreen),
            onPressed: () {
              setState(() {
                _currentMessages.clear();
                _currentMessages.add(
                  ChatMessage(
                    text: '🌱 أهلاً بك في AgriSense AI! أنا هنا لمساعدتك في كل أسئلتك الزراعية.',
                    isUser: false,
                    time: _getCurrentTime(),
                    type: 'greeting',
                  ),
                );
              });
              _createNewSession();
            },
            tooltip: 'محادثة جديدة',
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: AppColors.primaryGreen),
            onPressed: _clearChat,
            tooltip: 'مسح المحادثة',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.primaryGreen),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('عن AgriSense AI'),
                  content: const Text(
                    'AgriSense AI هو مساعد ذكي متخصص في الزراعة. يمكنه الإجابة على أسئلتك حول:\n\n'
                    '• المحاصيل والنباتات\n'
                    '• الأمراض والآفات\n'
                    '• التوصيات الزراعية\n'
                    '• أفضل الممارسات الزراعية\n\n'
                    'جميع محادثاتك يتم حفظها تلقائياً!',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('حسناً'),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'معلومات',
          ),
        ],
      ),
      body: Row(
        children: [
          if (_showHistory)
            _buildHistorySidebar(),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: _currentMessages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 64,
                                color: AppColors.primaryGreen.withOpacity(0.3),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'ابدأ محادثة جديدة',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _currentMessages.length + (_isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (_isLoading && index == _currentMessages.length) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryGreen.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            AppColors.primaryGreen,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      "جاري التفكير...",
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            final message = _currentMessages[index];

                            return _ChatBubble(
                              text: message.text,
                              isUser: message.isUser,
                              time: message.time,
                              type: message.type,
                            );
                          },
                        ),
                ),
                _buildInputArea(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'السجل',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () {
                    setState(() {
                      _showHistory = false;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _allSessions.isEmpty
                ? const Center(
                    child: Text(
                      'لا توجد محادثات سابقة',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _allSessions.length,
                    itemBuilder: (context, index) {
                      final session = _allSessions[index];
                      final isActive = _currentSessionId == session.id;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primaryGreen.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: isActive
                              ? Border.all(
                                  color: AppColors.primaryGreen,
                                  width: 1,
                                )
                              : null,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          title: Text(
                            session.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                              color: isActive
                                  ? AppColors.primaryGreen
                                  : AppColors.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            _formatDate(session.createdAt),
                            style: const TextStyle(fontSize: 11),
                          ),
                          onTap: () => _loadSession(session),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: const Row(
                                  children: [
                                    Icon(Icons.delete, size: 16),
                                    SizedBox(width: 8),
                                    Text('حذف'),
                                  ],
                                ),
                                onTap: () => _showDeleteConfirmation(session.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'اليوم ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (dateToCheck == yesterday) {
      return 'أمس';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              onSubmitted: (_) => _sendMessage(),
              textInputAction: TextInputAction.send,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'اسأل عن أي شيء زراعي...',
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(
                    color: AppColors.primaryGreen,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: AppColors.primaryGreen.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(
                    color: AppColors.primaryGreen,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppColors.backgroundLight,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Icon(
                    Icons.agriculture,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _isLoading ? null : _sendMessage,
            child: Container(
              decoration: BoxDecoration(
                color: _isLoading
                    ? AppColors.primaryGreen.withOpacity(0.5)
                    : AppColors.primaryGreen,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(
                _isLoading ? Icons.hourglass_empty : Icons.send,
                color: Colors.white,
                size: 24,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final String time;
  final String type;

  const _ChatBubble({
    required this.text,
    required this.isUser,
    required this.time,
    this.type = 'normal',
  });

  Color _getBubbleColor() {
    if (isUser) {
      return AppColors.primaryGreen;
    }

    switch (type) {
      case 'error':
        return Colors.red.withOpacity(0.1);
      case 'greeting':
        return AppColors.primaryGreen.withOpacity(0.1);
      default:
        return AppColors.surfaceLight;
    }
  }

  Color _getTextColor() {
    if (isUser) {
      return Colors.white;
    }

    switch (type) {
      case 'error':
        return Colors.red;
      default:
        return AppColors.textPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            decoration: BoxDecoration(
              color: _getBubbleColor(),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isUser ? 18 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              text,
              style: TextStyle(
                color: _getTextColor(),
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}