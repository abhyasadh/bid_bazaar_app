class AccountSettingsState {
  final bool isLoading;
  final bool isChanged;
  final bool canCheckBiometrics;
  final String? imageName;

  AccountSettingsState({
    required this.isLoading,
    required this.isChanged,
    required this.canCheckBiometrics,
    this.imageName,
  });

  factory AccountSettingsState.initialState() =>
      AccountSettingsState(isLoading: false, canCheckBiometrics: false, isChanged: false, imageName: null);

  AccountSettingsState copyWith({
    bool? isLoading,
    bool? isChanged,
    bool? canCheckBiometrics,
    String? imageName,
  }) {
    return AccountSettingsState(
      isLoading: isLoading ?? this.isLoading,
      isChanged: isChanged ?? this.isChanged,
      canCheckBiometrics: canCheckBiometrics ?? this.canCheckBiometrics,
      imageName: imageName ?? this.imageName,
    );
  }
}