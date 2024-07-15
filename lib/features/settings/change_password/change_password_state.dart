class ChangePasswordState {
  final bool isLoading;

  ChangePasswordState({
    required this.isLoading,
  });

  factory ChangePasswordState.initialState() =>
      ChangePasswordState(isLoading: false,);

  ChangePasswordState copyWith({
    bool? isLoading,
  }) {
    return ChangePasswordState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}