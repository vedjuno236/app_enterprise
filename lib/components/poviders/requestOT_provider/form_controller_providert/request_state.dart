class FormValidateOTState {
  final bool isValid;

  const FormValidateOTState({this.isValid = false});

  FormValidateOTState copyWith(
      {bool? isValid, DateTime? selectedDateStart, DateTime? selectedDateEnd}) {
    return FormValidateOTState(
      isValid: isValid ?? this.isValid,
    );
  }
}
