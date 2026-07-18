// import 'package:flutter/material.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/services/gemini_service.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';

// class FertilizationPlanPage extends StatefulWidget {
//   const FertilizationPlanPage({super.key});

//   @override
//   State<FertilizationPlanPage> createState() => _FertilizationPlanPageState();
// }

// class _FertilizationPlanPageState extends State<FertilizationPlanPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _cropController = TextEditingController();
//   final _soilController = TextEditingController();
//   String _selectedStage = 'بداية النمو';
//   bool _isLoading = false;
//   String? _planResult;

//   final List<String> _stages = [
//     'بداية النمو',
//     'النمو الخضري',
//     'قبل التزهير',
//     'مرحلة التزهير',
//     'مرحلة عقد الثمار',
//     'مرحلة النضج'
//   ];

//   @override
//   void dispose() {
//     _cropController.dispose();
//     _soilController.dispose();
//     super.dispose();
//   }

//   Future<void> _generatePlan() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//       _planResult = null;
//     });

//     try {
//       final plan = await GeminiService.getFertilizationPlan(
//         cropName: _cropController.text,
//         growthStage: _selectedStage,
//         soilType: _soilController.text.isNotEmpty ? _soilController.text : null,
//       );

//       setState(() {
//         _planResult = plan;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('حدث خطأ: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('خطة التسميد الذكية', style: TextStyle(fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             _buildHeader(),
//             const SizedBox(height: 24),
//             Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   _buildLabel('اسم المحصول'),
//                   const SizedBox(height: 8),
//                   TextFormField(
//                     controller: _cropController,
//                     textAlign: TextAlign.right,
//                     decoration: _buildInputDecoration('مثال: قمح، طماطم، بطاطس'),
//                     validator: (v) => v!.isEmpty ? 'يرجى إدخال اسم المحصول' : null,
//                   ),
//                   const SizedBox(height: 16),
//                   _buildLabel('مرحلة النمو الحالية'),
//                   const SizedBox(height: 8),
//                   DropdownButtonFormField<String>(
//                     initialValue: _selectedStage,
//                     alignment: Alignment.centerRight,
//                     decoration: _buildInputDecoration(''),
//                     items: _stages.map((s) => DropdownMenuItem(
//                       value: s,
//                       child: Text(s, textDirection: TextDirection.rtl),
//                     )).toList(),
//                     onChanged: (v) => setState(() => _selectedStage = v!),
//                   ),
//                   const SizedBox(height: 16),
//                   _buildLabel('نوع التربة (اختياري)'),
//                   const SizedBox(height: 8),
//                   TextFormField(
//                     controller: _soilController,
//                     textAlign: TextAlign.right,
//                     decoration: _buildInputDecoration('مثال: طينية، رملية، صفراء'),
//                   ),
//                   const SizedBox(height: 24),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 55,
//                     child: ElevatedButton(
//                       onPressed: _isLoading ? null : _generatePlan,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primaryGreen,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       ),
//                       child: _isLoading
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : const Text(
//                               'توليد خطة التسميد بواسطة Gemini',
//                               style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//                             ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (_planResult != null) ...[
//               const SizedBox(height: 32),
//               const Divider(),
//               const SizedBox(height: 16),
//               const Text(
//                 'الخطة المقترحة من Gemini:',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
//               ),
//               const SizedBox(height: 16),
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppColors.backgroundLight,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
//                 ),
//                 child: MarkdownBody(
//                   data: _planResult!,
//                   styleSheet: MarkdownStyleSheet(
//                     p: const TextStyle(fontSize: 15, height: 1.6, color: AppColors.textPrimary),
//                     h1: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                     h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     listBullet: const TextStyle(fontSize: 15, color: AppColors.primaryGreen),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 40),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.primaryGreen.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: const Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   'استخدم ذكاء Gemini الاصطناعي',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryGreen),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   'احصل على خطة تسميد علمية مخصصة لمحصولك بناءً على مرحلة نموه وظروف التربة (خدمة مجانية).',
//                   textAlign: TextAlign.right,
//                   style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(width: 16),
//           Icon(Icons.auto_awesome, color: AppColors.primaryGreen, size: 40),
//         ],
//       ),
//     );
//   }

//   Widget _buildLabel(String text) {
//     return Text(
//       text,
//       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
//     );
//   }

//   InputDecoration _buildInputDecoration(String hint) {
//     return InputDecoration(
//       hintText: hint,
//       hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
//       filled: true,
//       fillColor: AppColors.backgroundLight,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide.none,
//       ),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//     );
//   }
// }
