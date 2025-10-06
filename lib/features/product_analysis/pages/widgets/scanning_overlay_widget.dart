// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fooda_best/core/utilities/configs/app_typography.dart';
// import 'package:fooda_best/core/utilities/configs/colors.dart';

// class ScanningOverlayWidget extends StatefulWidget {
//   const ScanningOverlayWidget({super.key});

//   @override
//   State<ScanningOverlayWidget> createState() => _ScanningOverlayWidgetState();
// }

// class _ScanningOverlayWidgetState extends State<ScanningOverlayWidget>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat();

//     _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 250.w,
//             height: 250.h,
//             decoration: BoxDecoration(
//               border: Border.all(color: AllColors.white, width: 2.w),
//               borderRadius: BorderRadius.circular(12.r),
//             ),
//             child: Stack(
//               children: [
//                 _buildCorner(Alignment.topLeft),
//                 _buildCorner(Alignment.topRight),
//                 _buildCorner(Alignment.bottomLeft),
//                 _buildCorner(Alignment.bottomRight),

//                 AnimatedBuilder(
//                   animation: _animation,
//                   builder: (context, child) {
//                     return Positioned(
//                       top: _animation.value * (250.h - 4.h),
//                       left: 12.w,
//                       right: 12.w,
//                       child: Container(
//                         height: 2.h,
//                         decoration: BoxDecoration(
//                           color: AllColors.green,
//                           boxShadow: [
//                             BoxShadow(
//                               color: AllColors.green.withValues(alpha: 0.6),
//                               blurRadius: 8.r,
//                               spreadRadius: 2.r,
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),

//           SizedBox(height: 32.h),

//           Text(
//             'Point your camera at a barcode',
//             style: tm16.copyWith(
//               color: AllColors.white,
//               fontWeight: FontWeight.w500,
//             ),
//             textAlign: TextAlign.center,
//           ),

//           SizedBox(height: 8.h),

//           Text(
//             'Make sure the barcode is well lit and clearly visible',
//             style: tm14.copyWith(color: AllColors.white.withValues(alpha: 0.8)),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCorner(Alignment alignment) {
//     return Align(
//       alignment: alignment,
//       child: Container(
//         width: 24.w,
//         height: 24.h,
//         decoration: BoxDecoration(
//           border: Border(
//             top:
//                 alignment == Alignment.topLeft ||
//                     alignment == Alignment.topRight
//                 ? BorderSide(color: AllColors.green, width: 4.w)
//                 : BorderSide.none,
//             bottom:
//                 alignment == Alignment.bottomLeft ||
//                     alignment == Alignment.bottomRight
//                 ? BorderSide(color: AllColors.green, width: 4.w)
//                 : BorderSide.none,
//             left:
//                 alignment == Alignment.topLeft ||
//                     alignment == Alignment.bottomLeft
//                 ? BorderSide(color: AllColors.green, width: 4.w)
//                 : BorderSide.none,
//             right:
//                 alignment == Alignment.topRight ||
//                     alignment == Alignment.bottomRight
//                 ? BorderSide(color: AllColors.green, width: 4.w)
//                 : BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }
// }
