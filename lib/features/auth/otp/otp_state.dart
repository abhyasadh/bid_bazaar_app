class OTPState {
  final bool isLoading;
  final int timerCountDown;
  final bool isResendButtonDisabled;

  OTPState({
    required this.isLoading,
    required this.timerCountDown,
    required this.isResendButtonDisabled
  });

  factory OTPState.initialState() =>
      OTPState(isLoading: false, timerCountDown: 60, isResendButtonDisabled: true,);

  OTPState copyWith({
    bool? isLoading,
    int? timerCountDown,
    bool? isResendButtonDisabled
  }) {
    return OTPState(
      isLoading: isLoading ?? this.isLoading,
      timerCountDown: timerCountDown ?? this.timerCountDown,
      isResendButtonDisabled: isResendButtonDisabled ?? this.isResendButtonDisabled,
    );
  }
}
