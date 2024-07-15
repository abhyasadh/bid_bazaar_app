class LoginState {
  final String phone;
  final bool biometric;
  final bool isLoading;
  final bool rememberMe;

  LoginState({required this.phone, required this.biometric, required this.isLoading, this.rememberMe = true});

  factory LoginState.initialState(bool biometric) =>
      LoginState(phone: '', biometric: biometric, isLoading: false, rememberMe: true,);

  LoginState copyWith({
    String? phone,
    bool? biometric,
    bool? isLoading,
    bool? rememberMe,
  }) {
    return LoginState(
      phone: phone ?? this.phone,
      biometric: biometric ?? this.biometric,
      isLoading: isLoading ?? this.isLoading,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}
