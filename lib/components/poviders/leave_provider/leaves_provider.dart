import 'package:enterprise/components/poviders/leave_provider/leave_notifier.dart';
import 'package:enterprise/components/poviders/leave_provider/leave_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final leaveNotifierProvider =
    StateNotifierProvider<FormValidateNotifier, FormValidateState>(
        (ref) => FormValidateNotifier());
