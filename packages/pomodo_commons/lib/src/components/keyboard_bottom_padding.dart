import 'package:flutter/widgets.dart';

class KeyboardBottomPadding extends StatelessWidget {
  const KeyboardBottomPadding({
    super.key,
    required this.child,
    this.extraPadding = EdgeInsets.zero,
  });

  final Widget child;
  final EdgeInsets extraPadding;

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      top: false,
      child: Padding(
        padding: extraPadding + EdgeInsets.only(bottom: keyboardHeight),
        child: child,
      ),
    );
  }
}
