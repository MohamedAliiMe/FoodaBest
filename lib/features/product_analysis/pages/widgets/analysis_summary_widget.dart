// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fooda_best/core/utilities/configs/app_typography.dart';
// import 'package:fooda_best/core/utilities/configs/colors.dart';
// import 'package:fooda_best/features/product_analysis/data/models/analysis_model/analysis_model.dart';

// class AnalysisSummaryWidget extends StatelessWidget {
//   final AnalysisModel analysis;
//   final List<String> userAllergies;

//   const AnalysisSummaryWidget({
//     super.key,
//     required this.analysis,
//     required this.userAllergies,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: _getSafetyColor().withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(color: _getSafetyColor(), width: 1.w),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [

//           Row(
//             children: [
//               Icon(_getSafetyIcon(), color: _getSafetyColor(), size: 24.sp),
//               SizedBox(width: 8.w),
//               Text(
//                 _getSafetyTitle(),
//                 style: tb18.copyWith(color: _getSafetyColor()),
//               ),
//             ],
//           ),

//           SizedBox(height: 12.h),

//           if (analysis.summary != null && analysis.summary!.isNotEmpty) ...[
//             Text(
//               analysis.summary!,
//               style: tm14.copyWith(color: AllColors.black),
//             ),
//             SizedBox(height: 16.h),
//           ],


//           if (analysis.detectedAllergens != null &&
//               analysis.detectedAllergens!.isNotEmpty) ...[
//             _buildAllergensList(),
//             SizedBox(height: 16.h),
//           ],


//           if (analysis.warnings != null && analysis.warnings!.isNotEmpty) ...[
//             _buildWarningsList(),
//             SizedBox(height: 16.h),
//           ],


//           if (analysis.analysisTime != null) ...[
//             Text(
//               'Analyzed on ${_formatDate(analysis.analysisTime!)}',
//               style: tm12.copyWith(color: AllColors.grey),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildAllergensList() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(Icons.warning_amber, color: Colors.orange, size: 18.sp),
//             SizedBox(width: 6.w),
//             Text(
//               'Detected Allergens',
//               style: tm14.copyWith(
//                 color: AllColors.black,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 8.h),
//         Wrap(
//           spacing: 8.w,
//           runSpacing: 6.h,
//           children: analysis.detectedAllergens!.map((allergen) {
//             final isUserAllergen = userAllergies.any(
//               (userAllergen) =>
//                   userAllergen.toLowerCase().contains(allergen.toLowerCase()),
//             );

//             return Container(
//               padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//               decoration: BoxDecoration(
//                 color: isUserAllergen ? AllColors.red : Colors.orange,
//                 borderRadius: BorderRadius.circular(4.r),
//               ),
//               child: Text(
//                 allergen,
//                 style: tm12.copyWith(
//                   color: AllColors.white,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }

//   Widget _buildWarningsList() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(Icons.info_outline, color: Colors.blue, size: 18.sp),
//             SizedBox(width: 6.w),
//             Text(
//               'Warnings',
//               style: tm14.copyWith(
//                 color: AllColors.black,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 8.h),
//         ...analysis.warnings!
//             .map(
//               (warning) => Padding(
//                 padding: EdgeInsets.symmetric(vertical: 2.h),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: 4.w,
//                       height: 4.h,
//                       margin: EdgeInsets.only(top: 8.h, right: 8.w),
//                       decoration: BoxDecoration(
//                         color: Colors.blue,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     Expanded(
//                       child: Text(
//                         warning,
//                         style: tm14.copyWith(color: AllColors.black),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//             .toList(),
//       ],
//     );
//   }

//   Color _getSafetyColor() {
//     switch (analysis.safetyStatus?.toLowerCase()) {
//       case 'green':
//         return AllColors.green;
//       case 'yellow':
//         return Colors.orange;
//       case 'red':
//         return AllColors.red;
//       default:
//         return AllColors.grey;
//     }
//   }

//   IconData _getSafetyIcon() {
//     switch (analysis.safetyStatus?.toLowerCase()) {
//       case 'green':
//         return Icons.check_circle;
//       case 'yellow':
//         return Icons.warning;
//       case 'red':
//         return Icons.error;
//       default:
//         return Icons.help;
//     }
//   }

//   String _getSafetyTitle() {
//     switch (analysis.safetyStatus?.toLowerCase()) {
//       case 'green':
//         return 'Safe';
//       case 'yellow':
//         return 'Caution';
//       case 'red':
//         return 'Not Recommended';
//       default:
//         return 'Unknown';
//     }
//   }

//   String _formatDate(String isoDate) {
//     try {
//       final date = DateTime.parse(isoDate);
//       return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
//     } catch (e) {
//       return isoDate;
//     }
//   }
// }
