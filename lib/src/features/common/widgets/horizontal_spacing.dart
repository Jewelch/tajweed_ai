import '../../../base/screens/exports.dart';

class HorizontalSpacing extends StatelessWidget {
  const HorizontalSpacing(this.width, {super.key});

  final double width;

  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}
