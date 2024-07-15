class PasswordState {
  final bool isLoading;

  PasswordState({
    required this.isLoading,
  });

  factory PasswordState.initial() {
    return PasswordState(
      isLoading: false,
    );
  }

  PasswordState copyWith({
    bool? isLoading,
    String? imageName,
  }) {
    return PasswordState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}


