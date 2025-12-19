import 'package:flutter/material.dart';
import 'package:picroper/config/app_colors.dart';
import 'package:picroper/config/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.leading,
    this.actions,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      centerTitle: true,
      title: Text(
        title,
        style: AppTextStyles.headline2.copyWith(color: AppColors.onPrimary),
      ),
      leading: leading,
      actions: actions,
      elevation: 4, // Add some shadow for a "cool" effect
      shadowColor: Colors.black.withOpacity(0.2),
    );
  }
}
