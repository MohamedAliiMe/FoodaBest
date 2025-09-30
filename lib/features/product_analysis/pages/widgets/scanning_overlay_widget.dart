import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/utilities/configs/app_typography.dart';
import 'package:fooda_best/core/utilities/configs/colors.dart';

class ScanningOverlayWidget extends StatefulWidget {
  const ScanningOverlayWidget({super.key});

  @override
  State<ScanningOverlayWidget> createState() => _ScanningOverlayWidgetState();
}

class _ScanningOverlayWidgetState extends State<ScanningOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Scanning frame
          Container(
            width: 250.w,
            height: 250.h,
            decoration: BoxDecoration(
              border: Border.all(color: AllColors.white, width: 2.w),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Stack(
              children: [
                // Corner decorations
                _buildCorner(Alignment.topLeft),
                _buildCorner(Alignment.topRight),
                _buildCorner(Alignment.bottomLeft),
                _buildCorner(Alignment.bottomRight),

                // Scanning line
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Positioned(
                      top: _animation.value * (250.h - 4.h),
                      left: 12.w,
                      right: 12.w,
                      child: Container(
                        height: 2.h,
                        decoration: BoxDecoration(
                          color: AllColors.green,
                          boxShadow: [
                            BoxShadow(
                              color: AllColors.green.withValues(alpha: 0.6),
                              blurRadius: 8.r,
                              spreadRadius: 2.r,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 32.h),

          // Instructions
          Text(
            'Point your camera at a barcode',
            style: tm16.copyWith(
              color: AllColors.white,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8.h),

          Text(
            'Make sure the barcode is well lit and clearly visible',
            style: tm14.copyWith(color: AllColors.white.withValues(alpha: 0.8)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 24.w,
        height: 24.h,
        decoration: BoxDecoration(
          border: Border(
            top:
                alignment == Alignment.topLeft ||
                    alignment == Alignment.topRight
                ? BorderSide(color: AllColors.green, width: 4.w)
                : BorderSide.none,
            bottom:
                alignment == Alignment.bottomLeft ||
                    alignment == Alignment.bottomRight
                ? BorderSide(color: AllColors.green, width: 4.w)
                : BorderSide.none,
            left:
                alignment == Alignment.topLeft ||
                    alignment == Alignment.bottomLeft
                ? BorderSide(color: AllColors.green, width: 4.w)
                : BorderSide.none,
            right:
                alignment == Alignment.topRight ||
                    alignment == Alignment.bottomRight
                ? BorderSide(color: AllColors.green, width: 4.w)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:fooda_best/core/utilities/configs/colors.dart';

// class ScannerOverlay extends StatelessWidget {
//   const ScannerOverlay({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(painter: _ScannerOverlayPainter(), child: Container());
//   }
// }

// class _ScannerOverlayPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final width = size.width;
//     final height = size.height;
//     final scanAreaSize = width * 0.7;
//     final scanAreaLeft = (width - scanAreaSize) / 2;
//     final scanAreaTop = (height - scanAreaSize) / 2;
//     final scanAreaRight = scanAreaLeft + scanAreaSize;
//     final scanAreaBottom = scanAreaTop + scanAreaSize;

//     // Create the overlay path (everything except the scan area)
//     final backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, width, height));

//     final scanAreaPath = Path()
//       ..addRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromLTRB(
//             scanAreaLeft,
//             scanAreaTop,
//             scanAreaRight,
//             scanAreaBottom,
//           ),
//           const Radius.circular(12),
//         ),
//       );

//     // Subtract the scan area from the background
//     final finalPath = Path.combine(
//       PathOperation.difference,
//       backgroundPath,
//       scanAreaPath,
//     );

//     // Draw the semi-transparent overlay
//     canvas.drawPath(finalPath, Paint()..color = Colors.black.withOpacity(0.5));

//     // Draw the scan area border
//     final borderPaint = Paint()
//       ..color = AllColors.blue
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 3.0;

//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//         Rect.fromLTRB(scanAreaLeft, scanAreaTop, scanAreaRight, scanAreaBottom),
//         const Radius.circular(12),
//       ),
//       borderPaint,
//     );

//     // Draw corner indicators
//     final cornerPaint = Paint()
//       ..color = AllColors.blue
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 5.0;

//     final cornerLength = scanAreaSize * 0.1;

//     // Top-left corner
//     canvas.drawLine(
//       Offset(scanAreaLeft, scanAreaTop + cornerLength),
//       Offset(scanAreaLeft, scanAreaTop),
//       cornerPaint,
//     );
//     canvas.drawLine(
//       Offset(scanAreaLeft, scanAreaTop),
//       Offset(scanAreaLeft + cornerLength, scanAreaTop),
//       cornerPaint,
//     );

//     // Top-right corner
//     canvas.drawLine(
//       Offset(scanAreaRight - cornerLength, scanAreaTop),
//       Offset(scanAreaRight, scanAreaTop),
//       cornerPaint,
//     );
//     canvas.drawLine(
//       Offset(scanAreaRight, scanAreaTop),
//       Offset(scanAreaRight, scanAreaTop + cornerLength),
//       cornerPaint,
//     );

//     // Bottom-right corner
//     canvas.drawLine(
//       Offset(scanAreaRight, scanAreaBottom - cornerLength),
//       Offset(scanAreaRight, scanAreaBottom),
//       cornerPaint,
//     );
//     canvas.drawLine(
//       Offset(scanAreaRight, scanAreaBottom),
//       Offset(scanAreaRight - cornerLength, scanAreaBottom),
//       cornerPaint,
//     );

//     // Bottom-left corner
//     canvas.drawLine(
//       Offset(scanAreaLeft + cornerLength, scanAreaBottom),
//       Offset(scanAreaLeft, scanAreaBottom),
//       cornerPaint,
//     );
//     canvas.drawLine(
//       Offset(scanAreaLeft, scanAreaBottom),
//       Offset(scanAreaLeft, scanAreaBottom - cornerLength),
//       cornerPaint,
//     );

//     // Draw scan line
//     final scanLinePaint = Paint()
//       ..shader = LinearGradient(
//         colors: [
//           AllColors.blue.withOpacity(0),
//           AllColors.blue,
//           AllColors.blue.withOpacity(0),
//         ],
//         begin: Alignment.centerLeft,
//         end: Alignment.centerRight,
//       ).createShader(Rect.fromLTWH(scanAreaLeft, 0, scanAreaSize, 0))
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 3.0;

//     canvas.drawLine(
//       Offset(scanAreaLeft + 10, scanAreaTop + scanAreaSize / 2),
//       Offset(scanAreaRight - 10, scanAreaTop + scanAreaSize / 2),
//       scanLinePaint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
