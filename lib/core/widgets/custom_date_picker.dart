import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/utilities/configs/app_typography.dart';
import 'package:fooda_best/core/utilities/configs/colors.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateChanged;

  const CustomDatePicker({
    super.key,
    required this.initialDate,
    required this.onDateChanged,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _dayController;
  late FixedExtentScrollController _yearController;

  late int selectedMonth;
  late int selectedDay;
  late int selectedYear;

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    selectedMonth = widget.initialDate.month - 1;
    selectedDay = widget.initialDate.day - 1;
    selectedYear = widget.initialDate.year;

    _monthController = FixedExtentScrollController(initialItem: selectedMonth);
    _dayController = FixedExtentScrollController(initialItem: selectedDay);
    _yearController = FixedExtentScrollController(
      initialItem: selectedYear - 1950,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyDateChanged();
    });
  }

  @override
  void dispose() {
    _monthController.dispose();
    _dayController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  void _updateDayController() {
    final daysInMonth = _getDaysInMonth(selectedYear, selectedMonth + 1);
    if (selectedDay >= daysInMonth) {
      selectedDay = daysInMonth - 1;
      _dayController.animateToItem(
        selectedDay,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  void _notifyDateChanged() {
    final selectedDate = DateTime(
      selectedYear,
      selectedMonth + 1,
      selectedDay + 1,
    );
    widget.onDateChanged(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      decoration: BoxDecoration(
        color: AllColors.white,
        border: Border.all(color: AllColors.grayLight),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [_buildMonthPicker(), _buildDayPicker(), _buildYearPicker()],
      ),
    );
  }

  Widget _buildMonthPicker() {
    return Expanded(
      child: CupertinoPicker(
        scrollController: _monthController,
        itemExtent: 50.h,
        onSelectedItemChanged: (index) {
          setState(() {
            selectedMonth = index;
            _updateDayController();
            _notifyDateChanged();
          });
        },
        children: months.map((month) => _buildPickerItem(month)).toList(),
      ),
    );
  }

  Widget _buildDayPicker() {
    return Expanded(
      child: CupertinoPicker(
        scrollController: _dayController,
        itemExtent: 50.h,
        onSelectedItemChanged: (index) {
          setState(() {
            selectedDay = index;
            _notifyDateChanged();
          });
        },
        children: List.generate(
          _getDaysInMonth(selectedYear, selectedMonth + 1),
          (index) => _buildPickerItem('${index + 1}'.padLeft(2, '0')),
        ),
      ),
    );
  }

  Widget _buildYearPicker() {
    return Expanded(
      child: CupertinoPicker(
        scrollController: _yearController,
        itemExtent: 50.h,
        onSelectedItemChanged: (index) {
          setState(() {
            selectedYear = 1950 + index;
            _updateDayController();
            _notifyDateChanged();
          });
        },
        children: List.generate(
          100,
          (index) => _buildPickerItem('${1950 + index}'),
        ),
      ),
    );
  }

  Widget _buildPickerItem(String text) {
    return Center(
      child: Text(text, style: tm16.copyWith(color: AllColors.black)),
    );
  }
}
