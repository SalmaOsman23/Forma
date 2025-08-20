
import 'package:flutter/material.dart';
import 'package:forma/core/utils/app_styles.dart';
import 'package:get/get.dart';

class ScreenLayout extends StatefulWidget {
  final String appBarTitle;
  final Widget body;
  final Widget? action;
  final bool isLeadingNeeded;
  const ScreenLayout(
      {super.key,
      required this.appBarTitle,
      required this.body,
      this.action,
      this.isLeadingNeeded = true});

  @override
  State<ScreenLayout> createState() => _ScreenLayoutState();
}

class _ScreenLayoutState extends State<ScreenLayout> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(widget.appBarTitle, style: AppStyles.headlineLarge(context).copyWith(color: Theme.of(context).colorScheme.primary)),
        leading:
            //! To check if the leading arrow is needed or not
            widget.isLeadingNeeded
                ? GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.chevron_left_rounded,
                      color: theme.primary,
                      size: 34,
                    ),
                  )
                : null,
        actions: [
          if (widget.action != null) ...[widget.action!],
        ],
      ),
      body: GestureDetector(onTap: () => FocusScope.of(context).unfocus(), child: widget.body),
    );
  }
}
