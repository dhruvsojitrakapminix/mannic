import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/repositories/favorites_repository.dart';
import '../../data/services/app_config.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final name = box.read<String>('user_name') ?? 'Guest User';
    final age = box.read<int>('user_age');

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(S.lg),
          children: [
            SizedBox(height: S.lg),
            Center(
              child: CircleAvatar(
                radius: 50.r,
                backgroundColor: AppColors.card,
                child: Icon(Icons.person,
                    size: 50.sp, color: AppColors.textHint),
              ),
            ),
            SizedBox(height: S.lg),
            Center(
              child: Text(
                name,
                style: T.h2,
                textAlign: TextAlign.center,
              ),
            ),
            if (age != null) ...[
              SizedBox(height: S.xs),
              Center(
                child: Text('$age years old', style: T.small),
              ),
            ],
            SizedBox(height: S.xs),
            Center(
              child: Text(
                'guest@NoveFlix – Movies, TV & Live.app',
                style: T.small.copyWith(color: AppColors.textHint),
              ),
            ),
            SizedBox(height: S.xxl),

            // ── Activity ──────────────────────
            Text('ACTIVITY', style: _label),
            SizedBox(height: S.sm),
            Obx(() {
              final count = FavoritesRepo.i.favorites.length;
              return _Tile(
                icon: Icons.favorite_border,
                title: 'My Favorites',
                trailing: count > 0 ? '$count' : null,
                onTap: () => Get.toNamed(Routes.FAVORITES),
              );
            }),
            _Tile(
              icon: Icons.history,
              title: 'Watch History',
              onTap: () {},
            ),

            SizedBox(height: S.xl),

            // ── Account ───────────────────────
            Text('ACCOUNT', style: _label),
            SizedBox(height: S.sm),
            _Tile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {},
            ),
            _Tile(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () {},
            ),
            _Tile(
              icon: Icons.shield_outlined,
              title: 'Privacy & Data',
              onTap: () {},
            ),

            SizedBox(height: S.xl),

            // ── Support ───────────────────────
            Text('SUPPORT', style: _label),
            SizedBox(height: S.sm),
            _Tile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () async {
                final url = Uri.parse('https://example.com/support');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
            ),
            _Tile(
              icon: Icons.share_outlined,
              title: 'Share App',
              onTap: () {
                final cfg = AppConfigStore.instance.appConfig.appUpdateConfig;
                final storeUrl = Platform.isAndroid
                    ? cfg.androidStoreUrl
                    : cfg.appStoreUrl;
                final url = storeUrl.isNotEmpty ? storeUrl : 'https://NoveFlix – Movies, TV & Live.app';
                Share.share('Watch movies & shows on NoveFlix – Movies, TV & Live — $url');
              },
            ),
            _Tile(
              icon: Icons.star_outline,
              title: 'Rate Us',
              onTap: () async {
                final url = Uri.parse(
                    'https://play.google.com/store/apps/details?id=com.movie.dobedo.app');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url,
                      mode: LaunchMode.externalApplication);
                }
              },
            ),
            _Tile(
              icon: Icons.info_outline,
              title: 'About',
              onTap: () {},
            ),

            SizedBox(height: S.xxl),
            Center(
              child: Text(
                'NoveFlix – Movies, TV & Live v1.0.0',
                style: T.small.copyWith(color: AppColors.textHint),
              ),
            ),
            SizedBox(height: S.xl),
          ],
        ),
      ),
    );
  }

  static final _label = T.small.copyWith(
    fontSize: 11.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.0,
    color: AppColors.textSub,
  );
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback? onTap;

  const _Tile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: S.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(R.md),
        border: Border.all(color: AppColors.divider),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: T.title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailing != null) ...[
              Text(trailing!, style: T.small),
              SizedBox(width: S.sm),
            ],
            const Icon(Icons.chevron_right, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}