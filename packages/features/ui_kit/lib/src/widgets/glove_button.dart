import 'lab_button.dart';

/// Legacy alias for [LabButton]. Prefer [LabButton] in new code.
@Deprecated('Use LabButton instead.')
class GloveButton extends LabButton {
  const GloveButton({
    super.key,
    required super.label,
    super.onPressed,
    super.icon,
    super.isPrimary = true,
    super.isLoading = false,
    super.backgroundColor,
  });
}
