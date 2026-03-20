import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationState extends Equatable {
  final int selectedIndex;
  final bool isBottomNavVisible;

  const NavigationState({
    required this.selectedIndex,
    this.isBottomNavVisible = true,
  });

  NavigationState copyWith({
    int? selectedIndex,
    bool? isBottomNavVisible,
  }) {
    return NavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isBottomNavVisible: isBottomNavVisible ?? this.isBottomNavVisible,
    );
  }

  @override
  List<Object> get props => [selectedIndex, isBottomNavVisible];
}

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState(selectedIndex: 0));

  void setTab(int index) {
    emit(state.copyWith(
      selectedIndex: index,
      // Always show navbar when changing tabs
      isBottomNavVisible: true,
    ));
  }

  void setBottomNavVisible(bool visible) {
    emit(state.copyWith(isBottomNavVisible: visible));
  }
}
