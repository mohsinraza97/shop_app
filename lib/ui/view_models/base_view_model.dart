import 'package:flutter/material.dart';
import '../../data/enums/data_state.dart';
import '../../data/enums/loading_state.dart';

abstract class BaseViewModel with ChangeNotifier {
  LoadingState _loadingState = LoadingState.loaded;
  DataState _dataState = DataState.none;

  LoadingState get loadingState => _loadingState;

  set loadingState(LoadingState state) {
    _loadingState = state;
    notifyListeners();
  }

  DataState get dataState => _dataState;

  set dataState(DataState state) {
    _dataState = state;
    notifyListeners();
  }
}
