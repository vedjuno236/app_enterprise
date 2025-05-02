class FormValidateState {
  final bool isValid;

  const FormValidateState({this.isValid = false});

  FormValidateState copyWith(
      {bool? isValid, DateTime? selectedDateStart, DateTime? selectedDateEnd}) {
    return FormValidateState(
      isValid: isValid ?? this.isValid,
    );
  }
}
