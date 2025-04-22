abstract class ScrollEvent {}

class InitScrollController extends ScrollEvent {}

class ScrollPositionChanged extends ScrollEvent {
  final double position;
  final double maxScrollExtent;
  ScrollPositionChanged({
    required this.position,
    required this.maxScrollExtent,
  });
}
