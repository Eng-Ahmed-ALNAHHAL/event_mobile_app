import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staggered_animated_widget/animation_direction.dart';
import 'package:staggered_animated_widget/staggered_animated_widget.dart';

import '../../../app/components/constants/assets_manager.dart';
import '../../../app/components/constants/buttons_manager.dart';
import '../../../app/components/constants/color_manager.dart';
import '../../../app/components/constants/font_manager.dart';
import '../../../app/components/constants/general_strings.dart';
import '../../../app/components/constants/icons_manager.dart';
import '../../../app/components/constants/notification_handler.dart';
import '../../../app/components/constants/size_manager.dart';
import '../../../app/components/constants/text_form_manager.dart';
import '../../../app/components/constants/variables_manager.dart';
import '../../../app/components/tranlate_massages/translate_massage.dart';
import '../../../domain/local_models/models.dart';
import '../../bloc_state_managment/bloc_manage.dart';
import '../../bloc_state_managment/states.dart';
import 'login_model_view.dart';

class LoginRoute extends StatefulWidget {
  const LoginRoute({super.key});

  @override
  State<LoginRoute> createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  late final LoginModelView _model;

  @override
  void initState() {
    super.initState();
    _model = LoginModelView();
    _model.context = context;
    _model.start();
  }

  errorNoti(String msg) => errorNotification(
      context: context,
      description: translateErrorMessage(msg, context),
      backgroundColor:
          VariablesManager.isDark ? Colors.grey.shade400 : Colors.white);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventsBloc, AppStates>(
        builder: (context, state) => getScaffold(),
        listener: (context, state) async {
          if (state is SignInWithGoogleStateError) {
            errorNotification(
                context: context,
                description: translateErrorMessage(state.error, context),
                backgroundColor: VariablesManager.isDark
                    ? Colors.grey.shade400
                    : Colors.white);
          }
          if (state is UserCreatedErrorState) {
            errorNotification(
                context: context,
                description: translateErrorMessage(state.error.code, context),
                backgroundColor: VariablesManager.isDark
                    ? Colors.grey.shade400
                    : Colors.white);
          }
          if (state is UserCreatedSuccessState) {
            _model.onCreateNewUser();
          }
          if (state is SignInWithGoogleUserExistState) {
            final docSnapshot = await FirebaseFirestore.instance
                .collection(GeneralStrings.users)
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get();

            if (docSnapshot.exists) {
              final data = docSnapshot.data();

              if (data != null && (data['additionalInfo'] != null)) {
                _model.onAddExistUser();
              } else {
                _model.onCreateNewUser();
              }
            } else {
              if (kDebugMode) {
                print("User document does not exist.");
              }
            }
          }
          if (state is LoginErrorState) {
            errorNoti(state.error.code);
          }
          if (state is LoginSuccessState) {
            _model.navigateToHome();
          }
        });
  }

  Widget getScaffold() => Scaffold(
        appBar: AppBar(
          backgroundColor: ColorManager.primarySecond,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: IconsManager.arrowBack,
            color: ColorManager.primary,
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _model.formKey,
            child: Padding(
              padding: EdgeInsets.all(SizeManager.d20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StaggeredAnimatedWidget(
                    delay: SizeManager.i200,
                    direction: AnimationDirection.fromLeft,
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          GeneralStrings.login(context),
                          style: TextStyle(
                              fontWeight: FontWeightManager.bold,
                              fontSize: SizeManager.d50,
                              fontFamily: GeneralStrings.cormo,
                              color: VariablesManager.isDark
                                  ? Colors.white
                                  : ColorManager.primarySecond),
                        )),
                  ),
                  SizedBox(
                    height: SizeManager.d30,
                  ),
                  StaggeredAnimatedWidget(
                    delay: SizeManager.i400,
                    direction: AnimationDirection.fromLeft,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(GeneralStrings.welcomeBack(context),
                          style: TextStyleManager.titleStyle(context)),
                    ),
                  ),
                  SizedBox(
                    height: SizeManager.d30,
                  ),
                  StaggeredAnimatedWidget(
                      delay: SizeManager.i600,
                      child: textFormField(
                        controller: _model.emailController,
                        hintText: GeneralStrings.ahmadEmail,
                        labelText: GeneralStrings.email(context),
                        prefix: Icon(IconsManager.email),
                        onFieldSubmitted: (p0) => toNextField,
                        validator: (p0) => validator(p0, context),
                        context: context,
                      )),
                  SizedBox(
                    height: SizeManager.d20,
                  ),
                  StaggeredAnimatedWidget(
                      delay: SizeManager.i800,
                      child: textFormField(
                          controller: _model.passwordController,
                          labelText: GeneralStrings.password(context),
                          prefix: Icon(IconsManager.key),
                          onFieldSubmitted: (p0) => toNextField,
                          validator: (p0) => validator(p0, context),
                          suffix: Icon(IconsManager.hide),
                          context: context)),
                  SizedBox(
                    height: SizeManager.d10,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: StaggeredAnimatedWidget(
                      delay: SizeManager.i900,
                      child: TextButton(
                        onPressed: () => _model.onForgetPasswordPress(),
                        child: Text(
                          GeneralStrings.forgetPassword(context),
                          style: TextStyle(
                            color: ColorManager.primarySecond,
                            fontSize: SizeManager.d12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeManager.d20,
                  ),
                  googleAndAppleButton(
                      delay: SizeManager.i1000,
                      onTap: () {
                        if (_model.formKey.currentState!.validate()) {
                          _model.onLoginPressed(
                            email: _model.emailController.text,
                            password: _model.passwordController.text,
                          );
                        }
                      },
                      nameOfButton: GeneralStrings.login(context),
                      sufixSvgAssetPath: AssetsManager.login,
                      color: ColorManager.primarySecond,
                      context: context),
                  SizedBox(
                    height: SizeManager.d30,
                  ),
                  StaggeredAnimatedWidget(
                    delay: SizeManager.i1200,
                    direction: AnimationDirection.fromLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: ColorManager.primary,
                          ),
                        ),
                        SizedBox(
                          width: SizeManager.d2,
                        ),
                        Text(GeneralStrings.or(context),
                            style: TextStyleManager.titleStyle(context)),
                        SizedBox(
                          width: SizeManager.d2,
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: ColorManager.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeManager.d20,
                  ),
                  googleAndAppleButton(
                      delay: SizeManager.i1400,
                      onTap: () => _model.onSignInwWithGooglePress(),
                      nameOfButton: GeneralStrings.signWithGoogle(context),
                      prefixSvgAssetPath: AssetsManager.google,
                      context: context),
                  SizedBox(height: SizeManager.d30),
                  Visibility(
                    visible: Platform.isIOS,
                    child: googleAndAppleButton(
                        delay: 1600,
                        nameOfButton: GeneralStrings.signWithApple(context),
                        prefixSvgAssetPath: AssetsManager.apple,
                        context: context),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
