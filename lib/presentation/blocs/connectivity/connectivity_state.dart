class ConnectivityState {
  final bool isConnected;
  final bool shouldShowMessage;

  ConnectivityState({
    required this.isConnected,
    this.shouldShowMessage = false,
  });

  ConnectivityState copyWith({bool? isConnected, bool? shouldShowMessage}) {
    return ConnectivityState(
      isConnected: isConnected ?? this.isConnected,
      shouldShowMessage: shouldShowMessage ?? this.shouldShowMessage,
    );
  }
}
