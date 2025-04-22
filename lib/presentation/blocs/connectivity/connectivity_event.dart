abstract class ConnectivityEvent {}

class ConnectivityChanged extends ConnectivityEvent {
  final bool isConnected;
  ConnectivityChanged(this.isConnected);
}

class InitConnectivity extends ConnectivityEvent {}
