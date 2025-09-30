import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/utilities/configs/app_typography.dart';
import 'package:fooda_best/core/utilities/configs/colors.dart';

class LoadingSkeletonWidget extends StatefulWidget {
  final String message;

  const LoadingSkeletonWidget({super.key, required this.message});

  @override
  State<LoadingSkeletonWidget> createState() => _LoadingSkeletonWidgetState();
}

class _LoadingSkeletonWidgetState extends State<LoadingSkeletonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
    return Column(
      children: [
        Center(
          child: CircularProgressIndicator(
            color: AllColors.blue,
            strokeWidth: 3.w,
          ),
        ),

        SizedBox(height: 16.h),

        Text(
          widget.message,
          style: tm14.copyWith(
            color: AllColors.grey,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 24.h),

        _buildSkeletonContent(),
      ],
    );
  }

  Widget _buildSkeletonContent() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 100.h,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AllColors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    width: 68.w,
                    height: 68.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      gradient: LinearGradient(
                        colors: [
                          AllColors.grey.withValues(alpha: 0.3),
                          AllColors.grey.withValues(alpha: 0.1),
                          AllColors.grey.withValues(alpha: 0.3),
                        ],
                        stops: [
                          _animation.value - 0.3,
                          _animation.value,
                          _animation.value + 0.3,
                        ].map((e) => e.clamp(0.0, 1.0)).toList(),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(width: 16.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSkeletonLine(width: double.infinity, height: 16.h),
                    SizedBox(height: 8.h),
                    _buildSkeletonLine(width: 120.w, height: 12.h),
                    SizedBox(height: 8.h),
                    _buildSkeletonLine(width: 80.w, height: 12.h),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        _buildSkeletonLine(width: double.infinity, height: 12.h),
        SizedBox(height: 8.h),
        _buildSkeletonLine(width: 250.w, height: 12.h),
        SizedBox(height: 8.h),
        _buildSkeletonLine(width: 180.w, height: 12.h),
      ],
    );
  }

  Widget _buildSkeletonLine({required double width, required double height}) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        double lineWidth = width;
        if (width == double.infinity) {
          lineWidth = MediaQuery.of(context).size.width - 40.w;
        }

        return Container(
          width: lineWidth,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            gradient: LinearGradient(
              colors: [
                AllColors.grey.withValues(alpha: 0.3),
                AllColors.grey.withValues(alpha: 0.1),
                AllColors.grey.withValues(alpha: 0.3),
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ),
          ),
        );
      },
    );
  }
}
