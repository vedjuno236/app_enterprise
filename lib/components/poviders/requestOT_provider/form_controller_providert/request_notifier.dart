import 'package:enterprise/components/poviders/requestOT_provider/form_controller_providert/request_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormValidateOTNotifier extends StateNotifier<FormValidateOTState> {
  final TextEditingController startDateController = TextEditingController();

  final TextEditingController noteController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();

  final TextEditingController endTimeController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DateTime? selectedDateStart; // Adding selectedDateStart
  DateTime? selectedDateEnd; // Adding selectedDateEnd

  FormValidateOTNotifier() : super(const FormValidateOTState()) {

  }

  @override
  void dispose() {
    startDateController.dispose();

    noteController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }
}
