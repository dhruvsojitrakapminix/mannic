import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import '../../widgets/bottom_nav.dart';
import '../cinema/cinema_view.dart';
import '../explore/explore_view.dart';
import '../for_you/for_you_view.dart';
import '../home/home_view.dart';
import '../search/search_view.dart';

class ShellView extends StatelessWidget {
  const ShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final idx = 0.obs;
    const pages = <Widget>[
      HomeView(),
      ForYouView(),
      ExploreView(),
      SearchView(),
      CinemaView(),
    ];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Obx(() => IndexedStack(index: idx.value, children: pages)),
      bottomNavigationBar: Obx(
            () => BottomNav(
          index: idx.value,
          onTap: (i) => idx.value = i,
        ),
      ),
    );
  }
}