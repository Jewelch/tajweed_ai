import '../../../../base/screens/exports.dart';

class FailureSnackbar extends SnackBar {
  final Exception exception;

  FailureSnackbar({super.key, required this.exception})
    : super(
        content: Text('An error occurred: ${exception.toString()}'),
        backgroundColor: Theme.of(globalContext).colorScheme.error,
      );
}
