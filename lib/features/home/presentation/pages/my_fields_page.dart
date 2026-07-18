// import 'package:flutter/material.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/widgets/custom_card.dart';
// import '../../../../core/services/api_service.dart';
// import '../../data/models/field_model.dart';
// import 'add_field_page.dart';
// import 'field_details_page.dart';

// class MyFieldsPage extends StatefulWidget {
//   const MyFieldsPage({super.key});

//   @override
//   State<MyFieldsPage> createState() => _MyFieldsPageState();
// }

// class _MyFieldsPageState extends State<MyFieldsPage> {
//   bool _isLoading = true;
//   List<FieldModel> _fields = [];
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _fetchFields();
//   }

//   Future<void> _fetchFields() async {
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });

//     try {
//       final result = await ApiService.getFields();
//       if (result['success']) {
//         final List<dynamic> data = result['data'];
//         setState(() {
//           _fields = data.map((json) => FieldModel.fromJson(json)).toList();
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _error = result['message'];
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('My Fields', style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.white,
//         foregroundColor: AppColors.textPrimary,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryGreen),
//             onPressed: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const AddFieldPage()),
//             ).then((_) => _fetchFields()),
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: _fetchFields,
//         child: _buildBody(),
//       ),
//     );
//   }

//   Widget _buildBody() {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (_error != null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Error: $_error', style: const TextStyle(color: Colors.red)),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _fetchFields,
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       );
//     }

//     if (_fields.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.agriculture, size: 64, color: Colors.grey),
//             const SizedBox(height: 16),
//             const Text('No fields added yet', style: TextStyle(color: Colors.grey, fontSize: 18)),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const AddFieldPage()),
//               ).then((_) => _fetchFields()),
//               style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
//               child: const Text('Add Your First Field', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: _fields.length,
//       itemBuilder: (context, index) {
//         final field = _fields[index];
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 16),
//           child: GestureDetector(
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => FieldDetailsPage(field: field)),
//             ),
//             child: CustomCard(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: AppColors.primaryGreen.withOpacity(0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(Icons.landscape, color: AppColors.primaryGreen),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           field.fieldName,
//                           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           '${field.acres} Acres • ${field.city}, ${field.government}',
//                           style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/services/api_service.dart';
import '../../data/models/field_model.dart';
import 'add_field_page.dart';
import 'field_details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyFieldsPage extends StatefulWidget {
  const MyFieldsPage({super.key});

  @override
  State<MyFieldsPage> createState() => _MyFieldsPageState();
}

class _MyFieldsPageState extends State<MyFieldsPage> {
  bool _isLoading = true;
  List<FieldModel> _fields = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchFields();
  }

  Future<void> _fetchFields() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await ApiService.getFields();
      if (result['success']) {
        final List<dynamic> data = result['data'];
        
       final prefs = await SharedPreferences.getInstance();

      final currentUserIdStr =
          ApiService.currentUserId ??
          prefs.getString('user_id');

      print("CURRENT USER ID = $currentUserIdStr");

      final int? currentUserId =
          int.tryParse(currentUserIdStr ?? '');
              setState(() {
          // تصفية الحقول بحيث تظهر حقول المستخدم الحالي فقط
          _fields = data
              .map((json) => FieldModel.fromJson(json))
              .where((field) {
                if (currentUserId != null) {
                  return field.userId == currentUserId;
                }
                return true; // في حال عدم وجود ID، نعرض الكل (للتوافق)
              })
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = result['message'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Fields', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryGreen),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddFieldPage()),
            ).then((_) => _fetchFields()),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchFields,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchFields,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_fields.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.agriculture, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No fields found for your account', style: TextStyle(color: Colors.grey, fontSize: 18)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddFieldPage()),
              ).then((_) => _fetchFields()),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
              child: const Text('Add Your First Field', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _fields.length,
      itemBuilder: (context, index) {
        final field = _fields[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FieldDetailsPage(field: field)),
            ),
            child: CustomCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.landscape, color: AppColors.primaryGreen),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          field.fieldName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${field.acres} Acres • ${field.city}, ${field.government}',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
