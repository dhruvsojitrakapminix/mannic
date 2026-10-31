import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class BottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;

  const BottomNav({super.key, required this.index, required this.onTap});

  static const _items = <_NavItem>[
    _NavItem(Icons.home, Icons.home_outlined, 'Home'),
    _NavItem(Icons.auto_awesome, Icons.auto_awesome_outlined, 'For you'),
    _NavItem(Icons.explore, Icons.explore_outlined, 'Explore'),
    _NavItem(Icons.search, Icons.search, 'Search'),
    _NavItem(Icons.movie, Icons.movie_outlined, 'Cinema'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg2,
      padding: EdgeInsets.only(top: 8.h, bottom: 12.h),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (i) {
            final selected = i == index;
            final item = _items[i];
            return GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selected ? item.active : item.icon,
                    color: selected ? AppColors.primary : AppColors.textHint,
                    size: 24.sp,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.label,
                    style: T.small.copyWith(
                      color:
                      selected ? AppColors.primary : AppColors.textHint,
                      fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData active;
  final String label;
  const _NavItem(this.icon, this.active, this.label);
}