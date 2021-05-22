import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:saanjalo/AuthBloc/authenticationbloc_bloc.dart';
import 'package:saanjalo/constants.dart';
import 'package:saanjalo/screens/homepage/view/homepage_view.dart';
import 'package:saanjalo/screens/login/cubit/login_cubit.dart';
import 'package:saanjalo/screens/login/widgets/button.dart';
import 'package:saanjalo/screens/login/widgets/fadeSlide.dart';
import 'package:saanjalo/screens/login/widgets/inputField.dart';

class LoginForm extends StatelessWidget {
  final Animation<double>? animation;
  LoginForm({this.animation});

  @override
  Widget build(BuildContext context) {
    var height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    var space = height > 650 ? kSpaceM : kSpaceS;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingL),
      child: Column(
        children: <Widget>[
          _EmailField(animation: animation),
          SizedBox(height: space),
          _PasswordField(animation: animation, space: space),
          SizedBox(height: space),
          _LoginButton(animation: animation, space: space),
          SizedBox(height: 2 * space),
          _GoogleButton(animation: animation, space: space),
          SizedBox(height: space),
          FadeSlideTransition(
            animation: animation!,
            additionalOffset: 4 * space,
            child: CustomButton(
              color: kBlack,
              textColor: kWhite,
              textBox: Text('Create a Bubble Account'),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({
    Key? key,
    required this.animation,
    required this.space,
  }) : super(key: key);

  final Animation<double>? animation;
  final double space;

  @override
  Widget build(BuildContext context) {
    return FadeSlideTransition(
      animation: animation!,
      additionalOffset: 3 * space,
      child: CustomButton(
        color: kWhite,
        textBox: Text(
          "Login With Google",
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: kBlack.withOpacity(0.5), fontWeight: FontWeight.bold),
        ),
        image: Image(
          image: AssetImage(kGoogleLogoPath),
          height: 48.0,
        ),
        onPressed: () {
          context.read<LoginCubit>().loginUsingGoogleSignIn();
        },
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    Key? key,
    required this.animation,
    required this.space,
  }) : super(key: key);

  final Animation<double>? animation;
  final double space;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) => FadeSlideTransition(
              animation: animation!,
              additionalOffset: 2 * space,
              child: CustomButton(
                color: kBlue,
                textBox: state.status == FormzStatus.submissionInProgress
                    ? CircularProgressIndicator()
                    : Text(
                        "Login to continue",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: kWhite, fontWeight: FontWeight.bold),
                      ),
                onPressed: state.status.isValidated
                    ? () =>
                        context.read<LoginCubit>().loginUsingEmailandpassword()
                    : () {},
              ),
            ));
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    Key? key,
    required this.animation,
    required this.space,
  }) : super(key: key);

  final Animation<double>? animation;
  final double space;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return FadeSlideTransition(
          animation: animation!,
          additionalOffset: space,
          child: CustomInputField(
            errorMessage: state.email.invalid ? "Invalid Password" : null,
            onChanged: (String value) =>
                context.read<LoginCubit>().updatePassword(value),
            label: 'Password',
            prefixIcon: Icons.lock,
            obscureText: true,
          ),
        );
      },
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({
    Key? key,
    required this.animation,
  }) : super(key: key);

  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return FadeSlideTransition(
      animation: animation!,
      additionalOffset: 0.0,
      child: CustomInputField(
        onChanged: (String value) =>
            context.read<LoginCubit>().updateEmail(value),
        label: 'Username or Email',
        prefixIcon: Icons.person,
      ),
    );
  }
}
