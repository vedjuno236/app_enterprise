import 'package:enterprise/components/poviders/leave_provider/leave_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormValidateNotifier extends StateNotifier<FormValidateState> {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController assignWorkController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();
  final TextEditingController accordingController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController processController = TextEditingController();
  final TextEditingController solutionController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();

  final TextEditingController endTimeController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DateTime? selectedDateStart; // Adding selectedDateStart
  DateTime? selectedDateEnd; // Adding selectedDateEnd

  FormValidateNotifier() : super(const FormValidateState()) {
    
      startDateController.addListener(_validateDateTime);
      endDateController.addListener(_validateDateTime);

      /// Annual and Maternity
      assignWorkController.addListener(_validateAnnualMaternity);
      descriptionController.addListener(_validateAnnualMaternity);
      noteController.addListener(_validateAnnualMaternity);

      /// Reason
      reasonController.addListener(_validateReason);

      /// hospital

      /// Lakit and Sick
      conditionController.addListener(_validateLakitSick);
      accordingController.addListener(_validateLakitSick);

      placeController.addListener(_validateLakitSick);
      phoneController.addListener(_validateLakitSick);
      processController.addListener(_validateLakitSick);
      solutionController.addListener(_validateLakitSick);
    }

    void setSelectedDateStart(DateTime? date) {
      selectedDateStart = date;
      state = state.copyWith(
          selectedDateStart:
              date); // Assuming FormValidateState has a selectedDateStart property
    }

    void setSelectedDateEnd(DateTime? date) {
      selectedDateEnd = date;
      state = state.copyWith(
          selectedDateEnd:
              date); // Assuming FormValidateState has a selectedDateEnd property
    }

    void _validateDateTime() {
      final isDateValid = formKey.currentState?.validate() ?? false;
      state = state.copyWith(isValid: isDateValid);
    }

    void _validateReason() {
      final isReasonValid = formKey.currentState?.validate() ?? false;
      state = state.copyWith(isValid: isReasonValid);
    }

    void _validateAnnualMaternity() {
      final isValid = formKey.currentState?.validate() ?? false;
      state = state.copyWith(isValid: isValid);
    }

    void _validateLakitSick() {
      final isLakitSickValid = formKey.currentState?.validate() ?? false;
      state = state.copyWith(isValid: isLakitSickValid);
  }

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    assignWorkController.dispose();
    descriptionController.dispose();
    noteController.dispose();
    reasonController.dispose();
    conditionController.dispose();
    accordingController.dispose();
    placeController.dispose();
    phoneController.dispose();
    processController.dispose();
    solutionController.dispose();
    super.dispose();
  }
}
