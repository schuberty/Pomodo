import 'package:flutter/widgets.dart';

class UnfocusInputField extends StatelessWidget {
  const UnfocusInputField({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}
