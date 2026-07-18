// import 'package:flutter/material.dart';
// import 'package:timeago/timeago.dart' as timeago;

// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/widgets/custom_card.dart';
// import '../../../../core/services/api_service.dart';
// import '../../../home/data/models/community_post_model.dart';

// class CommunityPage extends StatefulWidget {
//   const CommunityPage({super.key});

//   @override
//   State<CommunityPage> createState() => _CommunityPageState();
// }

// class _CommunityPageState extends State<CommunityPage> {
//   List<CommunityPostModel> _posts = [];
//   bool _isLoading = true;
//   String? _error;
//   final TextEditingController _postController = TextEditingController();
//   final Map<int, TextEditingController> _commentControllers = {};
//   final Map<int, bool> _expandedComments = {};

//   @override
//   void initState() {
//     super.initState();
//     _fetchPosts();
//   }

//   @override
//   void dispose() {
//     _postController.dispose();
//     for (var controller in _commentControllers.values) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   Future<void> _fetchPosts() async {
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });

//     final result = await ApiService.getCommunityPosts();

//     if (mounted) {
//       setState(() {
//         if (result['success']) {
//           final List<dynamic> data = result['data'];
//           _posts = data.map((json) => CommunityPostModel.fromJson(json)).toList();
//         } else {
//           _error = result['message'];
//         }
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _createPost() async {
//     if (_postController.text.trim().isEmpty) {
//       return;
//     }

//     final content = _postController.text.trim();
//     _postController.clear();

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('جاري نشر المنشور...')),
//     );

//     final result = await ApiService.createPost(content);

//     if (mounted) {
//       if (result['success']) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('تم نشر المنشور بنجاح!')),
//         );
//         _fetchPosts();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('فشل النشر: ${result['message']}')),
//         );
//       }
//     }
//   }

//   Future<void> _addComment(int postId) async {
//     final controller = _commentControllers[postId];
//     if (controller == null || controller.text.trim().isEmpty) {
//       return;
//     }

//     final comment = controller.text.trim();
//     controller.clear();

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('جاري إضافة التعليق...')),
//     );

//     final result = await ApiService.addComment(
//       postId: postId,
//       comment: comment,
//     );

//     if (mounted) {
//       if (result) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('تم إضافة التعليق بنجاح!')),
//         );
//         _fetchPosts();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('فشل إضافة التعليق')),
//         );
//       }
//     }
//   }

//   void _showCreatePostDialog() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//           left: 20,
//           right: 20,
//           top: 20,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             const Text(
//               'إنشاء منشور جديد',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _postController,
//               maxLines: 5,
//               textAlign: TextAlign.right,
//               textDirection: TextDirection.rtl,
//               decoration: InputDecoration(
//                 hintText: 'بماذا تفكر؟',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 filled: true,
//                 fillColor: AppColors.backgroundLight,
//               ),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _createPost();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primaryGreen,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   'نشر',
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showCommentsSheet(CommunityPostModel post) {
//     if (!_commentControllers.containsKey(post.id)) {
//       _commentControllers[post.id] = TextEditingController();
//     }

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//           left: 20,
//           right: 20,
//           top: 20,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             const Text(
//               'التعليقات',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _commentControllers[post.id],
//               maxLines: 3,
//               textAlign: TextAlign.right,
//               textDirection: TextDirection.rtl,
//               decoration: InputDecoration(
//                 hintText: 'اكتب تعليقك...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 filled: true,
//                 fillColor: AppColors.backgroundLight,
//               ),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _addComment(post.id);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primaryGreen,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   'إضافة تعليق',
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: _fetchPosts,
//           child: Column(
//             children: [
//               _buildHeader(),
//               Expanded(
//                 child: _isLoading
//                     ? const Center(
//                         child: CircularProgressIndicator(
//                           color: AppColors.primaryGreen,
//                         ),
//                       )
//                     : _error != null
//                         ? _buildErrorState()
//                         : ListView(
//                             padding: const EdgeInsets.all(20),
//                             children: [
//                               _buildCreatePostCard(),
//                               const SizedBox(height: 24),
//                               const Text(
//                                 'المناقشات الأخيرة',
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 textDirection: TextDirection.rtl,
//                               ),
//                               const SizedBox(height: 16),
//                               if (_posts.isEmpty)
//                                 const Center(child: Text('لا توجد منشورات حالياً'))
//                               else
//                                 ..._posts.map((post) => _buildPostItem(post)),
//                             ],
//                           ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.small(
//         onPressed: _showCreatePostDialog,
//         backgroundColor: AppColors.primaryGreen,
//         child: const Icon(
//           Icons.add,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             _error!,
//             style: const TextStyle(color: Colors.red),
//           ),
//           TextButton(
//             onPressed: _fetchPosts,
//             child: const Text(
//               'إعادة المحاولة',
//               style: TextStyle(color: AppColors.primaryGreen),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
//       decoration: const BoxDecoration(
//         color: AppColors.primaryGreen,
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(40),
//           bottomRight: Radius.circular(40),
//         ),
//       ),
//       child: const Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Text(
//             'مجتمعنا',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 30,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'تواصل مع المزارعين والخبراء الآخرين',
//             style: TextStyle(
//               color: Colors.white70,
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCreatePostCard() {
//     return GestureDetector(
//       onTap: _showCreatePostDialog,
//       child: CustomCard(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             const Icon(
//               Icons.image_outlined,
//               color: AppColors.primaryGreen,
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 decoration: BoxDecoration(
//                   color: AppColors.backgroundLight,
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//                 child: const Text(
//                   'بماذا تفكر؟',
//                   style: TextStyle(color: AppColors.textSecondary),
//                   textAlign: TextAlign.right,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 16),
//             const CircleAvatar(
//               backgroundColor: AppColors.primaryGreen,
//               child: Icon(Icons.person, color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPostItem(CommunityPostModel post) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: CustomCard(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 const Icon(Icons.more_horiz, color: AppColors.textSecondary),
//                 const Spacer(),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       post.authorName,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.primaryGreen,
//                         fontSize: 15,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       timeago.format(
//                         DateTime.parse(post.createdAt),
//                         locale: 'ar',
//                       ),
//                       style: const TextStyle(
//                         color: AppColors.textSecondary,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(width: 12),
//                 CircleAvatar(
//                   radius: 22,
//                   backgroundColor: AppColors.primaryGreen,
//                   child: Text(
//                     post.authorName.isNotEmpty ? post.authorName[0].toUpperCase() : '?',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               post.content,
//               style: const TextStyle(height: 1.6, fontSize: 15),
//               textAlign: TextAlign.right,
//               textDirection: TextDirection.rtl,
//             ),
//             const SizedBox(height: 16),
//             const Divider(),
//             Row(
//               children: [
//                 InkWell(
//                   borderRadius: BorderRadius.circular(20),
//                   onTap: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('تمت مشاركة المنشور')),
//                     );
//                   },
//                   child: const Padding(
//                     padding: EdgeInsets.all(4),
//                     child: Icon(
//                       Icons.share_outlined,
//                       size: 21,
//                       color: AppColors.textSecondary,
//                     ),
//                   ),
//                 ),
//                 const Spacer(),
//                 _buildActionItem(
//                   Icons.chat_bubble_outline,
//                   post.commentsCount.toString(),
//                   onTap: () => _showCommentsSheet(post),
//                 ),
//                 const SizedBox(width: 24),
//                 _buildActionItem(
//                   post.isLiked ? Icons.favorite : Icons.favorite_border,
//                   post.likesCount.toString(),
//                   color: post.isLiked ? Colors.red : AppColors.textSecondary,
//                   onTap: () async {
//                     final success = await ApiService.likePost(post.id);
//                     if (success) {
//                       setState(() {
//                         final idx = _posts.indexOf(post);
//                         if (idx != -1) {
//                           _posts[idx] = post.copyWith(
//                             isLiked: !post.isLiked,
//                             likesCount: post.isLiked
//                                 ? post.likesCount - 1
//                                 : post.likesCount + 1,
//                           );
//                         }
//                       });
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionItem(
//     IconData icon,
//     String count, {
//     VoidCallback? onTap,
//     Color? color,
//   }) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(20),
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.all(4),
//         child: Row(
//           children: [
//             Text(
//               count,
//               style: TextStyle(
//                 color: color ?? AppColors.textSecondary,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(width: 6),
//             Icon(
//               icon,
//               size: 21,
//               color: color ?? AppColors.textSecondary,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/services/api_service.dart';
import '../../../community/data/models/community_post_model.dart';
import './comments_page.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  List<CommunityPostModel> _posts = [];
  bool _isLoading = true;
  String? _error;
  final TextEditingController _postController = TextEditingController();
  final Map<int, bool> _likedPosts = {};

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await ApiService.getCommunityPosts();

    if (mounted) {
      setState(() {
        if (result['success']) {
          final List<dynamic> data = result['data'];
          print("POSTS FROM API:");
          print(data);
          
          _posts = data.map((json) => CommunityPostModel.fromJson(json)).toList();
          // تهيئة حالة الإعجاب من البيانات الفعلية
          for (var post in _posts) {
            _likedPosts[post.id] = post.isLiked;
          }
        } else {
          _error = result['message'];
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _createPost() async {
    if (_postController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى كتابة محتوى المنشور')),
      );
      return;
    }

    final content = _postController.text.trim();
    _postController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('جاري نشر المنشور...')),
    );

    final result = await ApiService.createPost(content);

    if (mounted) {
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم نشر المنشور بنجاح!')),
        );
        await Future.delayed(const Duration(milliseconds: 500));
        _fetchPosts();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل النشر: ${result['message']}')),
        );
      }
    }
  }

  Future<void> _toggleLike(CommunityPostModel post) async {
    final isCurrentlyLiked = _likedPosts[post.id] ?? false;
    
    // تحديث الواجهة فوراً
    setState(() {
      _likedPosts[post.id] = !isCurrentlyLiked;
    });

    final result = await ApiService.likePost(post.id);

    if (!result) {
      // إرجاع الحالة السابقة في حالة الفشل
      setState(() {
        _likedPosts[post.id] = isCurrentlyLiked;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل تحديث الإعجاب')),
        );
      }
    } else {
      // إعادة تحميل البيانات لضمان التحديث
      await Future.delayed(const Duration(milliseconds: 300));
      _fetchPosts();
    }
  }

  void _showCreatePostDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'إنشاء منشور جديد',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _postController,
                maxLines: 5,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  hintText: 'بماذا تفكر؟ شارك خبرتك مع المجتمع...',
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryGreen),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                  ),
                  filled: true,
                  fillColor: AppColors.backgroundLight,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _createPost();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'نشر المنشور',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToProfile(String? userId, String userName) {
    if (userId != null && userId.isNotEmpty) {
      // الانتقال إلى صفحة البروفايل
      Navigator.pushNamed(
        context,
        '/profile',
        arguments: userId,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('لا يمكن الوصول إلى بروفايل $userName')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchPosts,
          color: AppColors.primaryGreen,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryGreen,
                        ),
                      )
                    : _error != null
                        ? _buildErrorState()
                        : ListView(
                            padding: const EdgeInsets.all(16),
                            children: [
                              _buildCreatePostCard(),
                              const SizedBox(height: 24),
                              if (_posts.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 40),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.forum_outlined,
                                        size: 64,
                                        color: AppColors.primaryGreen.withOpacity(0.3),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'لا توجد منشورات حالياً',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'كن أول من ينشر في المجتمع',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Column(
                                  children: _posts.map((post) => _buildPostItem(post)).toList(),
                                ),
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePostDialog,
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _error!,
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _fetchPosts,
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryGreen, Color(0xFF4CAF50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'مجتمع المزارعين',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'تواصل مع المزارعين والخبراء وشارك خبراتك',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatePostCard() {
    return GestureDetector(
      onTap: _showCreatePostDialog,
      child: CustomCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(
              Icons.edit_outlined,
              color: AppColors.primaryGreen,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  'بماذا تفكر؟',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: AppColors.primaryGreen.withOpacity(0.2),
              child: const Icon(Icons.person, color: AppColors.primaryGreen, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostItem(CommunityPostModel post) {
    final isLiked = _likedPosts[post.id] ?? false;
   print('postId=${post.id}');
print('author=${post.authorName}');
print('likes=${post.likesCount}');
print('comments=${post.commentsCount}');
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CustomCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // رأس المنشور (المؤلف والوقت)
            GestureDetector(
              onTap: () => _navigateToProfile(post.authorId, post.authorName),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          post.authorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timeago.format(
                            DateTime.parse(post.createdAt),
                            locale: 'ar',
                          ),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildUserAvatar(post.authorName, post.authorImage),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // محتوى المنشور
            Text(
              post.content,
              style: const TextStyle(
                height: 1.6,
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 16),
            
            // إحصائيات المنشور
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem('${post.likesCount}', Icons.favorite_outline, Colors.red),
                  _buildStatItem('${post.commentsCount}', Icons.comment_outlined, AppColors.primaryGreen),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // أزرار التفاعل
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_outline,
                  label: 'إعجاب',
                  color: isLiked ? Colors.red : AppColors.textSecondary,
                  onPressed: () => _toggleLike(post),
                ),
                _buildActionButton(
                  icon: Icons.comment_outlined,
                  label: 'تعليق',
                  color: AppColors.textSecondary,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentsPage(post: post),
                      ),
                    ).then((_) => _fetchPosts());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar(String userName, String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(imageUrl),
        onBackgroundImageError: (exception, stackTrace) {},
        child: const SizedBox(),
      );
    }
    
    return CircleAvatar(
      radius: 24,
      backgroundColor: AppColors.primaryGreen,
      child: Text(
        userName.isNotEmpty ? userName[0].toUpperCase() : '?',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          count,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
