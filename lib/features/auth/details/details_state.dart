class DetailsState {
  final bool isLoading;
  final String? imageName;

  DetailsState({
    required this.isLoading,
    this.imageName,
  });

  factory DetailsState.initial() {
    return DetailsState(
      isLoading: false,
      imageName: null,
    );
  }

  DetailsState copyWith({
    bool? isLoading,
    String? imageName,
  }) {
    return DetailsState(
      isLoading: isLoading ?? this.isLoading,
      imageName: imageName ?? this.imageName,
    );
  }
}


