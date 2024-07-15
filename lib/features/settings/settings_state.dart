class SettingsState {
  final bool isLoading;

  SettingsState({
    required this.isLoading,
  });

  factory SettingsState.initialState() =>
      SettingsState(isLoading: false,);

  SettingsState copyWith({
    bool? isLoading,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
