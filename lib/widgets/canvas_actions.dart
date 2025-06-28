import 'canvas_elements.dart';

enum CanvasActionType { add, remove }

class CanvasAction {
  final CanvasActionType type;
  final CanvasElement element;

  CanvasAction({required this.type, required this.element});

  CanvasAction clone() => CanvasAction(
        type: type,
        element: element.clone(),
      );
}
