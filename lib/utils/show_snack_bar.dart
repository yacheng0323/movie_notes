import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ShowSnackBarHelper {
  final BuildContext context;
  final String title;
  final Color? backgroundColor = Colors.black;
  final Color iconColor;

  final IconData iconData;

  ShowSnackBarHelper.successSnackBar({
    required BuildContext context,
  }) : this._(
          title: 'Success',
          context: context,
          iconData: Symbols.check_circle_filled,
          iconColor: Colors.green,
        );
  ShowSnackBarHelper.errorSnackBar({
    required BuildContext context,
  }) : this._(
          title: 'Error',
          context: context,
          iconData: Symbols.cancel,
          iconColor: Colors.red,
        );

  ShowSnackBarHelper._({
    required this.title,
    required this.iconData,
    required this.context,
    required this.iconColor,
  });
  void showSnackbar(
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.fixed,
        content: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            enableFeedback: false,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 4.0,
                  sigmaY: 4.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor?.withAlpha(158),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(21, 22, 0, 23),
                        child: Icon(
                          iconData,
                          color: iconColor,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(9.5, 0, 0, 0),
                          child: Text(message),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
