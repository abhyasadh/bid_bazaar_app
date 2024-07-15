class PhoneState {
  final bool isLoading;

  PhoneState({
    required this.isLoading,
  });

  factory PhoneState.initialState() =>
      PhoneState(isLoading: false,);

  PhoneState copyWith({
    bool? isLoading,
  }) {
    return PhoneState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
