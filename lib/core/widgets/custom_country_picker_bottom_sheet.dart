import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/utilities/configs/app_typography.dart';
import 'package:fooda_best/core/utilities/configs/colors.dart';
import 'package:fooda_best/translations/locale_keys.g.dart';

class CountryModel {
  final String name;
  final String flag;
  final String code;
  final String dialCode;

  CountryModel({
    required this.name,
    required this.flag,
    required this.code,
    required this.dialCode,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name'] as String,
      flag: json['flag'] as String,
      code: json['code'] as String,
      dialCode: json['dial_code'] as String,
    );
  }
}

class CustomCountryPickerBottomSheet extends StatefulWidget {
  const CustomCountryPickerBottomSheet({
    super.key,
    this.initialCountryCode,
    this.countries,
    required this.onCountryChanged,
    required this.onCountriesLoaded,
  });

  final String? initialCountryCode;
  final List<CountryModel>? countries;
  final Function(CountryModel) onCountryChanged;
  final Function(List<CountryModel>) onCountriesLoaded;

  static Future<void> show(
    BuildContext context, {
    String? initialCountryCode,
    List<CountryModel>? countries,
    required Function(CountryModel) onCountryChanged,
    required Function(List<CountryModel>) onCountriesLoaded,
  }) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AllColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => CustomCountryPickerBottomSheet(
        initialCountryCode: initialCountryCode,
        countries: countries,
        onCountryChanged: onCountryChanged,
        onCountriesLoaded: onCountriesLoaded,
      ),
    );
  }

  @override
  State<CustomCountryPickerBottomSheet> createState() =>
      _CustomCountryPickerBottomSheetState();
}

class _CustomCountryPickerBottomSheetState
    extends State<CustomCountryPickerBottomSheet> {
  List<CountryModel> _countries = [];
  List<CountryModel> _filteredCountries = [];
  bool _isLoading = true;
  CountryModel? _selectedCountry;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.countries == null) {
      _loadCountries();
    } else {
      _countries = widget.countries!;
      _filteredCountries = _countries;
      _isLoading = false;
    }
  }

  void _setFallbackCountries() {
    _countries = [
      CountryModel(name: 'Egypt', flag: '🇪🇬', code: 'EG', dialCode: '+20'),
      CountryModel(
        name: 'United States',
        flag: '🇺🇸',
        code: 'US',
        dialCode: '+1',
      ),
      CountryModel(
        name: 'United Kingdom',
        flag: '🇬🇧',
        code: 'GB',
        dialCode: '+44',
      ),
      CountryModel(
        name: 'Saudi Arabia',
        flag: '🇸🇦',
        code: 'SA',
        dialCode: '+966',
      ),
      CountryModel(
        name: 'United Arab Emirates',
        flag: '🇦🇪',
        code: 'AE',
        dialCode: '+971',
      ),
      CountryModel(name: 'Kuwait', flag: '🇰🇼', code: 'KW', dialCode: '+965'),
      CountryModel(name: 'Qatar', flag: '🇶🇦', code: 'QA', dialCode: '+974'),
      CountryModel(name: 'Bahrain', flag: '🇧🇭', code: 'BH', dialCode: '+973'),
      CountryModel(name: 'Oman', flag: '🇴🇲', code: 'OM', dialCode: '+968'),
      CountryModel(name: 'Jordan', flag: '🇯🇴', code: 'JO', dialCode: '+962'),
    ];
    _filteredCountries = List.from(_countries);

    _selectedCountry = _countries.first;


    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onCountryChanged(_selectedCountry!);
      widget.onCountriesLoaded(_countries);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCountries(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCountries = List.from(_countries);
      } else {
        _filteredCountries = _countries
            .where(
              (country) =>
                  country.name.toLowerCase().contains(query.toLowerCase()) ||
                  country.dialCode.contains(query) ||
                  country.code.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  Future<void> _loadCountries() async {
    try {
      debugPrint('🔄 Loading countries from assets...');
      final String response = await rootBundle.loadString(
        'assets/all_countries.json',
      );
      debugPrint(
        '✅ Countries file loaded successfully, length: ${response.length}',
      );

      if (response.isEmpty) {
        debugPrint('❌ Countries file is empty');
        throw Exception('Countries file is empty');
      }

      final List<dynamic> data = json.decode(response);
      debugPrint(
        '✅ JSON decoded successfully, countries count: ${data.length}',
      );

      if (data.isEmpty) {
        debugPrint('❌ Countries data is empty');
        throw Exception('Countries data is empty');
      }

      setState(() {
        _countries = data
            .map((country) => CountryModel.fromJson(country))
            .toList();
        _isLoading = false;

        _filteredCountries = List.from(_countries);
        debugPrint('✅ Countries processed: ${_countries.length}');

        if (_countries.isNotEmpty) {
          widget.onCountriesLoaded(_countries);
        }


        if (widget.initialCountryCode != null) {
          _selectedCountry = _countries.firstWhere(
            (country) => country.code == widget.initialCountryCode,
            orElse: () =>
                _countries.firstWhere((country) => country.code == 'EG'),
          );
        } else {

          _selectedCountry = _countries.firstWhere(
            (country) => country.code == 'EG',
          );
        }
        debugPrint('✅ Selected country: ${_selectedCountry?.name}');

        if (_selectedCountry != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onCountryChanged(_selectedCountry!);
          });
        }
      });
    } catch (e) {
      debugPrint('❌ Error loading countries: $e');
      setState(() {
        _isLoading = false;
        _setFallbackCountries();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.selectCountry.tr(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AllColors.black,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AllColors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(height: 1.h),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: AllColors.black),
              decoration: InputDecoration(
                hintText: 'Search country',
                hintStyle: TextStyle(color: AllColors.grey),
                prefixIcon: Icon(Icons.search, color: AllColors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: AllColors.grayLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: AllColors.grayLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: AllColors.grayLight),
                ),
                filled: true,
                fillColor: AllColors.white,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10.h,
                  horizontal: 16.w,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _filterCountries(value);
                });
              },
            ),
          ),
          Expanded(
            child: _filteredCountries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64.sp,
                          color: AllColors.grey,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          LocaleKeys.noCountriesFound.tr(),
                          style: tm16.copyWith(color: AllColors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredCountries.length,
                    itemBuilder: (context, index) {
                      final country = _filteredCountries[index];
                      return ListTile(
                        leading: Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AllColors.white,
                          ),
                          child: Center(child: Text(country.flag, style: tm20)),
                        ),
                        title: Text(country.name, style: tm16),
                        subtitle: Text(
                          country.dialCode,
                          style: tm16.copyWith(color: AllColors.grey),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedCountry = country;
                          });
                          widget.onCountryChanged(country);
                          Navigator.pop(context);
                        },
                        trailing: _selectedCountry?.code == country.code
                            ? Icon(Icons.check_circle, color: AllColors.blue)
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
