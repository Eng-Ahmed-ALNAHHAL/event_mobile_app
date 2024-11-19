import 'package:event_mobile_app/app/components/constants/color_manager.dart';
import 'package:event_mobile_app/app/components/constants/general_strings.dart';
import 'package:event_mobile_app/app/components/constants/notification_handler.dart';
import 'package:event_mobile_app/app/components/constants/variables_manager.dart';
import 'package:event_mobile_app/domain/local_models/models.dart';
import 'package:event_mobile_app/presentation/base/base_view_model.dart';
import 'package:event_mobile_app/presentation/bloc_state_managment/bloc_manage.dart';
import 'package:flutter/material.dart';

import '../../bloc_state_managment/events.dart';

class ForgetPasswordModelView extends BaseViewModel
    with ForgetPasswordModelFunctions {
  final emailController = TextEditingController();
  late final EventsBloc _bloc;

  late final BuildContext context;

  @override
  void dispose() {
    emailController.dispose();
  }

  @override
  resetPassword(String email) {
    _bloc.add(ResetPasswordEvent(email));
  }

  @override
  onResetPasswordSuccessState() {
    successNotification(
        context: context,
        description: GeneralStrings.passwordResetSuccess(context),
        backgroundColor: VariablesManager.isDark
            ? ColorManager.privateGrey
            : ColorManager.primary);
    navigateToMainRoute(context);
  }

  @override
  void start() {
    _bloc = EventsBloc.get(context);
  }
}

mixin ForgetPasswordModelFunctions {
  resetPassword(String email);

  onResetPasswordSuccessState();
}
