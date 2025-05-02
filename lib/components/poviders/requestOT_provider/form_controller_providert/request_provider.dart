import 'package:enterprise/components/poviders/requestOT_provider/form_controller_providert/request_notifier.dart';
import 'package:enterprise/components/poviders/requestOT_provider/form_controller_providert/request_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final RequestOTNotifierProvider =
    StateNotifierProvider<FormValidateOTNotifier, FormValidateOTState>(
        (ref) => FormValidateOTNotifier());
