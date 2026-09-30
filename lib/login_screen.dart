import 'dart:async';
import 'package:flutter/material.dart';

import 'app_screen.dart';
import 'login_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late final LoginViewModel _viewModel;
  late final StreamSubscription<AppScreen> _eventSubscription;

  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel();
    _eventSubscription = _viewModel.eventStream.listen((event) {

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        if (event is Home) {
          showSnackBar(context, 'Successfully logged in.');
        } else if (event is AlertMessage) {
          showSnackBar(context, event.message);
        }
      });

    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _eventSubscription.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<LoginUiState>(
        valueListenable: _viewModel.uiState,
        builder: (context, state, chile) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(state.errorMessage),

              Center(
                child: ElevatedButton(
                  onPressed: () => _viewModel.login('admin', 'password'),
                  child: const Text('Login'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
