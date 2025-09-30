import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/widgets/custom_continue_button.dart';
import 'package:fooda_best/features/authentication/data/models/user_model/user_model.dart';
import 'package:fooda_best/features/product_analysis/pages/view/product_detail_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/utilities/configs/app_typography.dart';
import '../../../../core/utilities/configs/colors.dart';
import '../../../../core/utilities/routes_navigator/navigator.dart';
import '../../../authentication/logic/authentication_cubit.dart';
import '../../../authentication/pages/view/phone_auth_page.dart';
import '../../logic/product_analysis_cubit.dart';

class ProductAnalysisPage extends StatefulWidget {
  const ProductAnalysisPage({super.key});

  @override
  State<ProductAnalysisPage> createState() => _ProductAnalysisPageState();
}

class _ProductAnalysisPageState extends State<ProductAnalysisPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // Scanner
  MobileScannerController? _scannerController;

  // Animation Controllers
  late AnimationController _resultAnimationController;
  late Animation<Offset> _resultSlideAnimation;

  // Image Picker
  final ImagePicker _imagePicker = ImagePicker();
  final GlobalKey _cameraKey = GlobalKey();
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  // State
  bool _hasScanned = false;
  bool _isInitialized = false;
  bool _isTorchOn = false;
  bool _isLoading = false;
  bool _showResults = false;
  bool _isManualMode = false;
  bool _isDialogOpen = false;
  String? _lastDetectedBarcode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _resultAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _resultSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _resultAnimationController,
            curve: Curves.easeOut,
          ),
        );

    _initializeScanner();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposeScanner();
    _resultAnimationController.dispose();
    super.dispose();
  }

  Future<void> _initializeScanner() async {
    try {
      _scannerController = MobileScannerController(
        detectionSpeed: DetectionSpeed.normal,
        facing: CameraFacing.back,
        torchEnabled: false,
        formats: [
          BarcodeFormat.ean13,
          BarcodeFormat.ean8,
          BarcodeFormat.upcA,
          BarcodeFormat.upcE,
          BarcodeFormat.code128,
          BarcodeFormat.code39,
        ],
      );

      setState(() => _isInitialized = true);
    } catch (e) {
      log('Error initializing scanner: $e');
      setState(() => _isInitialized = true);
    }
  }

  Future<void> _disposeScanner() async {
    try {
      if (_scannerController != null) {
        await _scannerController!.dispose();
        _scannerController = null;
      }
    } catch (e) {
      log('Error disposing scanner: $e');
    }
  }

  void _onBarcodeDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;

    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      final String barcode = barcodes.first.rawValue!;

      // Validate barcode length
      if (barcode.length < 6 || barcode.length > 14) {
        return;
      }

      // Store the last detected barcode for manual capture
      _lastDetectedBarcode = barcode;
      log('📱 Barcode detected and stored: $barcode');

      // Only auto-scan if not in manual mode and not loading
      if (!_hasScanned && !_isLoading && !_isManualMode && !_isDialogOpen) {
        log('✅ Auto-scanning barcode: $barcode');
        _startProductScan(barcode);
      }
    }
  }

  void _startProductScan(String barcode) {
    setState(() {
      _hasScanned = true;
      _isLoading = true;
      _showResults = true;
    });

    _scannerController?.stop();
    _resultAnimationController.forward();

    // Get user profile and start scanning
    final userModel = context.read<AuthenticationCubit>().state.user;
    if (userModel != null) {
      context.read<ProductAnalysisCubit>().scanProduct(barcode, userModel);
    } else {
      context.read<ProductAnalysisCubit>().reset();
      setState(() {
        _isLoading = false;
        _hasScanned = false;
        _showResults = false;
      });
      _resultAnimationController.reverse();
      _scannerController?.start();
    }
  }

  void _resetScanner() {
    context.read<ProductAnalysisCubit>().reset();

    setState(() {
      _hasScanned = false;
      _isLoading = false;
      _showResults = false;
      _isManualMode = false;
    });

    _resultAnimationController.reverse().then((_) {
      if (_scannerController != null && _isInitialized) {
        _scannerController!.start();
      }
    });
  }

  void _showManualCodeDialog() {
    setState(() {
      _isDialogOpen = true; // تعطيل الكاميرا
    });

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _buildManualCodeDialog(),
    ).then((_) {
      // لما الـ dialog يتقفل، نشغل الكاميرا تاني
      setState(() {
        _isDialogOpen = false;
      });
    });
  }

  void _manualCapture() async {
    // Manual capture - use the last detected barcode from live scanner
    _showSnackBar('Capturing and analyzing...');

    final userModel = context.read<AuthenticationCubit>().state.user;
    if (userModel != null) {
      setState(() {
        _hasScanned = true;
        _isLoading = true;
        _showResults = true;
      });

      _scannerController?.stop();
      _resultAnimationController.forward();

      // Use the last detected barcode from the live scanner
      if (_lastDetectedBarcode != null && _lastDetectedBarcode!.isNotEmpty) {
        log(
          '✅ Manual capture - using last detected barcode: $_lastDetectedBarcode',
        );
        context.read<ProductAnalysisCubit>().scanProduct(
          _lastDetectedBarcode!,
          userModel,
        );
      } else {
        log('❌ No barcode detected yet, please point camera at barcode first');
        _showSnackBar(
          'No barcode detected. Please point camera at a barcode first.',
        );
        _resetScanner();
      }
    }
  }

  Future<void> _analyzeImageForBarcode(
    File imageFile,
    UserModel userModel,
  ) async {
    try {
      log('🔍 Analyzing captured image for barcode...');

      // Try to detect barcode from the current scanner controller first
      if (_scannerController != null) {
        try {
          log('📸 Trying to detect barcode from current scanner...');
          final result = await _scannerController!.analyzeImage(imageFile.path);

          if (result != null && result.barcodes.isNotEmpty) {
            final barcode = result.barcodes.first.rawValue;
            if (barcode != null && barcode.isNotEmpty) {
              log('✅ Barcode detected from current scanner: $barcode');
              context.read<ProductAnalysisCubit>().scanProduct(
                barcode,
                userModel,
              );
              return;
            }
          }
        } catch (e) {
          log('⚠️ Current scanner analysis failed: $e');
        }
      }

      // Create a new scanner controller for image analysis
      log('🔄 Creating new scanner for image analysis...');
      final scannerController = MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
        facing: CameraFacing.back,
        torchEnabled: false,
        formats: [
          BarcodeFormat.ean13,
          BarcodeFormat.ean8,
          BarcodeFormat.upcA,
          BarcodeFormat.upcE,
          BarcodeFormat.code128,
          BarcodeFormat.code39,
          BarcodeFormat.qrCode,
        ],
      );

      // Analyze the captured image
      final result = await scannerController.analyzeImage(imageFile.path);
      await scannerController.dispose();

      if (result != null && result.barcodes.isNotEmpty) {
        final barcode = result.barcodes.first.rawValue;
        if (barcode != null && barcode.isNotEmpty) {
          log('✅ Barcode detected from new scanner: $barcode');
          context.read<ProductAnalysisCubit>().scanProduct(barcode, userModel);
          return;
        }
      }

      // If no barcode found, try the full image analysis
      log('🔄 No barcode found, trying full image analysis...');
      context.read<ProductAnalysisCubit>().captureAndAnalyzeImage(
        imageFile,
        userModel,
      );
    } catch (e) {
      log('❌ Error analyzing image: $e');
      // Fallback to full image analysis
      context.read<ProductAnalysisCubit>().captureAndAnalyzeImage(
        imageFile,
        userModel,
      );
    }
  }

  void _toggleTorch() {
    setState(() => _isTorchOn = !_isTorchOn);
    _scannerController?.toggleTorch();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        log('Image selected: ${image.path}');

        // Process the selected image
        final userModel = context.read<AuthenticationCubit>().state.user;
        if (userModel != null && mounted) {
          setState(() {
            _hasScanned = true;
            _isLoading = true;
            _showResults = true;
          });

          _resultAnimationController.forward();

          // For now, we'll analyze the image file
          if (mounted) {
            context.read<ProductAnalysisCubit>().captureAndAnalyzeImage(
              File(image.path),
              userModel,
            );
          }
        }
      }
    } catch (e) {
      log('Error picking image: $e');
      _showSnackBar('Error selecting image: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _logout() async {
    await context.read<AuthenticationCubit>().signOut();
    if (mounted) {
      popAllAndPushPage(context, const PhoneAuthPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar
            _buildTopAppBar(),

            SizedBox(height: 10.h),
            // Main Content
            Expanded(
              child: Stack(
                children: [
                  // Camera/Scanner View
                  _buildCameraView(),

                  // Controls when not showing results
                  if (!_showResults) ...[
                    _buildScannerOverlay(),
                    _buildBottomControls(),
                  ],

                  // Results Panel
                  if (_showResults) _buildResultsPanel(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      color: AllColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // User Profile Section
          BlocBuilder<AuthenticationCubit, AuthenticationState>(
            builder: (context, state) {
              final user = state.user;
              return Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AllColors.grey.withValues(alpha: 0.3),
                    radius: 20.r,
                    child: Text(
                      user?.firstName?.substring(0, 1).toUpperCase() ?? 'J',
                      style: tb16.copyWith(color: AllColors.black),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: tm12.copyWith(color: AllColors.grey),
                      ),
                      Text(
                        "${user?.firstName ?? 'June'} ${user?.lastName ?? 'Due'}"
                            .trim(),
                        style: tm14.copyWith(
                          color: AllColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),

          // Search Button
          GestureDetector(
            onTap: () {
              _logout();
              // _showSnackBar('Search feature coming soon');
            },
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AllColors.grey.withValues(alpha: 0.1),
              ),
              child: Icon(Icons.search, color: AllColors.black, size: 20.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    if (!_isInitialized || _scannerController == null) {
      return Container(
        decoration: BoxDecoration(
          color: AllColors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(100.r),
            topRight: Radius.circular(100.r),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AllColors.black),
              SizedBox(height: 16.h),
              Text(
                'Initializing camera...',
                style: tm14.copyWith(color: AllColors.black),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AllColors.black.withValues(alpha: 0.1),
            blurRadius: 15.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            // دخول Manual Mode فوراً عند السحب يمين/شمال
            if (details.primaryVelocity!.abs() > 300 && !_isManualMode) {
              setState(() {
                _isManualMode = true;
              });
            }
          },
          onDoubleTap: () {
            // الخروج من Manual Mode بـ double tap
            if (_isManualMode) {
              setState(() {
                _isManualMode = false;
              });
            }
          },
          child: Stack(
            children: [
              // Camera feed
              Positioned.fill(
                child: RepaintBoundary(
                  key: _repaintBoundaryKey,
                  child: MobileScanner(
                    controller: _scannerController!,
                    onDetect:
                        _onBarcodeDetect, // Always detect barcodes, even in manual mode
                  ),
                ),
              ),

              // Torch button
              Positioned(
                top: 20.h,
                right: 20.w,
                child: GestureDetector(
                  onTap: _toggleTorch,
                  child: Container(
                    width: 44.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isTorchOn
                          ? AllColors.yellow
                          : AllColors.grey.withValues(alpha: 0.8),
                    ),
                    child: Icon(
                      _isTorchOn ? Icons.flash_off : Icons.flash_on,
                      color: AllColors.white,
                      size: 24.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScannerOverlay() {
    // Only show in auto mode
    if (_isManualMode) return const SizedBox.shrink();

    return Center(
      child: SizedBox(
        width: 200.w,
        height: 200.h,
        child: CustomPaint(painter: CornerBorderPainter()),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 40.h,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Gallery button (always visible)
            _buildControlButton(
              icon: Icons.image_outlined,
              onTap: _pickImageFromGallery,
              backgroundColor: AllColors.grayLight.withValues(alpha: 0.2),
              iconColor: AllColors.white,
            ),

            // Manual capture button (center) - only shows in manual mode
            if (_isManualMode)
              // دائرة تصوير واضحة ومميزة
              GestureDetector(
                onTap: _manualCapture,
                child: Container(
                  width: 70.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AllColors.white,
                    border: Border.all(
                      color: AllColors.grey.withValues(alpha: 0.4),
                      width: 3.w,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AllColors.black.withValues(alpha: 0.25),
                        blurRadius: 12.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: AllColors.black,
                    size: 32.sp,
                  ),
                ),
              )
            else
              // في Auto Mode - فقط مساحة فارغة للتوضيح
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AllColors.white.withValues(alpha: 0.1),
                  border: Border.all(
                    color: AllColors.white.withValues(alpha: 0.3),
                    width: 1.w,
                  ),
                ),
                child: Icon(
                  Icons.swipe,
                  color: AllColors.white.withValues(alpha: 0.6),
                  size: 24.sp,
                ),
              ),

            // Keyboard button (Enter Code Manually)
            _buildControlButton(
              icon: Icons.keyboard_outlined,
              onTap: _showManualCodeDialog,
              backgroundColor: AllColors.white,
              borderColor: AllColors.grayLight,
              borderRadius: 100.r,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AllColors.black.withValues(alpha: 0.1),
                  blurRadius: 8.r,
                  offset: Offset(0, 2.h),
                ),
              ],
              gradientColors: AllColors.black.withValues(alpha: 0.1),

              iconColor: AllColors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    double? borderRadius,
    double? borderWidth,
    BoxShape? shape,
    Color? backgroundColor,
    Color? borderColor,
    List<BoxShadow>? boxShadow,
    Color? gradientColors,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60.w,
        height: 60.h,
        decoration: BoxDecoration(
          shape: shape ?? BoxShape.rectangle,
          color: backgroundColor ?? AllColors.white,
          borderRadius: shape == BoxShape.circle
              ? null
              : BorderRadius.circular(borderRadius ?? 10.r),
          border: Border.all(
            color: borderColor ?? AllColors.grey.withValues(alpha: 0.3),
            width: borderWidth ?? 2.w,
          ),
          boxShadow:
              boxShadow ??
              [
                BoxShadow(
                  color:
                      gradientColors ?? AllColors.black.withValues(alpha: 0.1),
                  blurRadius: 8.r,
                  offset: Offset(0, 2.h),
                ),
              ],
        ),
        child: Icon(icon, color: iconColor ?? AllColors.black, size: 24.sp),
      ),
    );
  }

  Widget _buildResultsPanel() {
    return SlideTransition(
      position: _resultSlideAnimation,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta! > 12) {
            _resetScanner();
          }
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AllColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.r),
                topRight: Radius.circular(25.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: AllColors.black.withValues(alpha: 0.1),
                  blurRadius: 20.r,
                  offset: Offset(0, -4.h),
                ),
              ],
            ),
            child: BlocBuilder<ProductAnalysisCubit, ProductAnalysisState>(
              builder: (context, state) {
                return _buildContent(context, state);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProductAnalysisState state) {
    switch (state.status) {
      case ProductAnalysisStatus.initial:
        return _buildEmptyState();
      case ProductAnalysisStatus.loading:
        if (state.product != null) {
          return _buildLoadingState('Analyzing ingredients...');
        } else {
          return _buildLoadingState('Scanning product...');
        }
      case ProductAnalysisStatus.loaded:
        if (state.product != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ProductDetailPage.show(
              context,
              product: state.product!,
              aiSummary: state.analysis?.summary,
              alternativeProducts: state.alternativeProducts,
            );
            _resetScanner();
          });
          return _buildLoadingState('Loading product details...');
        } else {
          return _buildEmptyState();
        }
      case ProductAnalysisStatus.error:
        return _buildErrorState(state.errorMessage ?? 'Unknown error occurred');
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 60.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner, size: 64.sp, color: AllColors.grey),
            SizedBox(height: 16.h),
            Text(
              'Scan a product to get started',
              style: tm16.copyWith(color: AllColors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 60.h),
        child: Column(
          children: [
            CircularProgressIndicator(color: AllColors.green),
            SizedBox(height: 16.h),
            Text(
              message,
              style: tm14.copyWith(color: AllColors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 60.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: AllColors.red),
            SizedBox(height: 16.h),
            Text('Error', style: tb18.copyWith(color: AllColors.red)),
            SizedBox(height: 8.h),
            Text(
              message,
              style: tm14.copyWith(color: AllColors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            CustomContinueButton(
              text: 'Try Again',
              onPressed: () {
                _resetScanner();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualCodeDialog() {
    final TextEditingController codeController = TextEditingController();

    return Dialog(
      backgroundColor: AllColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Enter Code Manually',
                  style: tb18.copyWith(
                    color: AllColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.close, color: AllColors.black, size: 24.sp),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Input field
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AllColors.grey.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextField(
                controller: codeController,
                keyboardType: TextInputType.number,
                maxLength: 14,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.w),
                  counterText: '',
                  hintText: 'Enter product barcode',
                  hintStyle: tm14.copyWith(color: AllColors.grey),
                ),
                style: tm16.copyWith(color: AllColors.black),
              ),
            ),

            // Character counter
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: codeController,
                  builder: (context, value, child) {
                    return Text(
                      '${value.text.length}/14',
                      style: tm12.copyWith(color: AllColors.grey),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Done button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final code = codeController.text.trim();
                  if (code.isNotEmpty && code.length >= 6) {
                    Navigator.of(context).pop();
                    _startProductScan(code);
                  } else {
                    _showSnackBar(
                      'Please enter a valid barcode (at least 6 digits)',
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AllColors.green,
                  foregroundColor: AllColors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Done',
                  style: tb16.copyWith(
                    color: AllColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_scannerController == null) return;
    switch (state) {
      case AppLifecycleState.resumed:
        _scannerController!.start();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _scannerController!.stop();
        break;
    }
  }
}

class CornerBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AllColors.white.withValues(alpha: 0.9)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double cornerLength = 25.0;
    const double cornerRadius = 2.0;

    // Top-left corner
    canvas.drawLine(
      const Offset(0, cornerRadius),
      const Offset(0, cornerLength),
      paint,
    );
    canvas.drawLine(
      const Offset(cornerRadius, 0),
      const Offset(cornerLength, 0),
      paint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(size.width - cornerLength, 0),
      Offset(size.width - cornerRadius, 0),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, cornerRadius),
      Offset(size.width, cornerLength),
      paint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(size.width, size.height - cornerLength),
      Offset(size.width, size.height - cornerRadius),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - cornerRadius, size.height),
      Offset(size.width - cornerLength, size.height),
      paint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(cornerLength, size.height),
      Offset(cornerRadius, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height - cornerRadius),
      Offset(0, size.height - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
