import 'dart:async';

import 'package:flutter/foundation.dart';
import 'app_screen.dart';

class LoginUiState {
  final bool isLoading;
  final String errorMessage;

  const LoginUiState({this.isLoading = false, this.errorMessage = ''});

  LoginUiState copyWith({bool? isLoading, String? errorMessage}) {
    return LoginUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class LoginViewModel {
  final ValueNotifier<LoginUiState> _uiState = ValueNotifier(LoginUiState());

  ValueListenable<LoginUiState> get uiState => _uiState;

  final StreamController<AppScreen> _events = StreamController<AppScreen>();

  Stream<AppScreen> get eventStream => _events.stream;

  void dispose() {
    _uiState.dispose();
    _events.close();
  }

  void login(String name, String password) async {
    _uiState.value = _uiState.value.copyWith(isLoading: true);

    await Future.delayed(const Duration(seconds: 2));

    if (name == "admin" && password == "password") {
      _uiState.value = _uiState.value.copyWith(isLoading: false);
      _events.sink.add(Home());
    } else {
      _uiState.value = _uiState.value.copyWith(
        isLoading: false,
        errorMessage: "Invalid credentials",
      );
      _events.sink.add(AlertMessage("Login Failed!"));
    }

    _uiState.value = _uiState.value.copyWith(isLoading: false);
  }
}
