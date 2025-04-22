import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_product_listing_app/core/services/connectivity_service.dart';
import 'connectivity_event.dart';
import 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService connectivityService;
  StreamSubscription? _connectivitySubscription;

  ConnectivityBloc(this.connectivityService)
    : super(ConnectivityState(isConnected: connectivityService.isConnected)) {
    on<InitConnectivity>(_onInitConnectivity);
    on<ConnectivityChanged>(_onConnectivityChanged);
  }

  void _onInitConnectivity(
    InitConnectivity event,
    Emitter<ConnectivityState> emit,
  ) {
    _connectivitySubscription = connectivityService.connectionStatusStream
        .listen((isConnected) {
          add(ConnectivityChanged(isConnected));
        });
  }

  void _onConnectivityChanged(
    ConnectivityChanged event,
    Emitter<ConnectivityState> emit,
  ) {
    final previousConnectionStatus = state.isConnected;
    final newConnectionStatus = event.isConnected;

    if (previousConnectionStatus != newConnectionStatus) {
      emit(
        state.copyWith(
          isConnected: newConnectionStatus,
          shouldShowMessage: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isConnected: newConnectionStatus,
          shouldShowMessage: false,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
