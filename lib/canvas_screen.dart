import 'dart:io';
import 'package:diary_app/auth_service.dart';
import 'package:diary_app/widgets/canvas_actions.dart';
import 'package:diary_app/widgets/canvas_elements.dart';
import 'package:diary_app/widgets/note_model.dart';
import 'package:diary_app/widgets/note_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CanvasScreen extends StatefulWidget {
  final Note? initialNote; // ✅ untuk edit note
  final Function(Note)? onSave; // ✅ callback saat note disimpan

  const CanvasScreen({
    super.key,
    this.initialNote,
    this.onSave,
  });

  @override
  State<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> {
  final titleController = TextEditingController();
  final elements = <CanvasElement>[];
  final undoStack = <CanvasAction>[];
  final redoStack = <CanvasAction>[];
  final brushPath = <Offset>[];

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  void _addText(String text) {
    final element = TextElement(
      id: const Uuid().v4(),
      text: text,
      position: const Offset(100, 150),
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
    setState(() {
      elements.add(element);
      undoStack.add(CanvasAction(type: CanvasActionType.add, element: element));
      redoStack.clear();
    });
  }

  void _addImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    final id = const Uuid().v4();
    final image = ImageElement(
      id: id,
      imageUrl: file.path, // local path (you can load via File later)
      position: const Offset(100, 200),
      size: const Size(120, 120),
    );
    setState(() {
      elements.add(image);
      undoStack.add(CanvasAction(type: CanvasActionType.add, element: image));
      redoStack.clear();
    });
  }

  void _showAddTextDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tambahkan Teks'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Tambah')),
        ],
      ),
    );
    if (result != null && result.trim().isNotEmpty) {
      _addText(result.trim());
    }
  }

  void _undo() {
    if (undoStack.isNotEmpty) {
      final action = undoStack.removeLast();
      setState(() {
        elements.removeWhere((e) => e.id == action.element.id);
        redoStack.add(action);
      });
    }
  }

  void _redo() {
    if (redoStack.isNotEmpty) {
      final action = redoStack.removeLast();
      setState(() {
        elements.add(action.element);
        undoStack.add(action);
      });
    }
  }

  void _saveNote() async {
    final user = AuthService.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User belum login')),
      );
      return;
    }

    final isEditing =
        widget.initialNote != null && widget.initialNote!.id.isNotEmpty;

    final note = Note(
      id: isEditing ? widget.initialNote!.id : '',
      title: titleController.text.trim().isEmpty
          ? 'Tanpa Judul'
          : titleController.text.trim(),
      createdAt: DateTime.now(),
      elements: elements,
      userId: user.id,
    );

    try {
      final savedNote = isEditing
          ? await NoteService.updateNote(note)
          : await NoteService.saveNote(note);

      widget.onSave?.call(savedNote);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan note: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialNote != null) {
      titleController.text = widget.initialNote!.title;
      elements.addAll(widget.initialNote!.elements.map((e) => e.clone()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          brushPath.add(details.localPosition);
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: titleController,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              hintText: 'Judul catatan',
              hintStyle: TextStyle(color: Colors.black),
              border: InputBorder.none,
            ),
          ),
          actions: [
            IconButton(icon: const Icon(Icons.undo), onPressed: _undo),
            IconButton(icon: const Icon(Icons.redo), onPressed: _redo),
            IconButton(icon: const Icon(Icons.save), onPressed: _saveNote),
          ],
        ),
        body: Stack(
          children: [
            CustomPaint(
              painter: CanvasPainter(brushPath),
              child: Container(),
            ),
            ...elements.map((e) {
              if (e is TextElement) {
                return Positioned(
                  left: e.position.dx,
                  top: e.position.dy,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        final index = elements.indexOf(e);
                        if (index != -1) {
                          elements[index] = e.copyWith(
                            position: e.position + details.delta,
                          );
                        }
                      });
                    },
                    child: Text(e.text, style: e.style),
                  ),
                );
              } else if (e is ImageElement) {
                return Positioned(
                  left: e.position.dx,
                  top: e.position.dy,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        final index = elements.indexOf(e);
                        if (index != -1) {
                          elements[index] = e.copyWith(
                            position: e.position + details.delta,
                          );
                        }
                      });
                    },
                    child: Image.file(
                      File(e.imageUrl),
                      width: e.size.width,
                      height: e.size.height,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                    ),
                  ),
                );
              } else {
                return const SizedBox(); // fallback jika tipe tidak dikenal
              }
            }).toList(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: const Icon(Icons.brush),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Brush aktif. Geser jari di canvas 🎨')),
                    );
                  }),
              IconButton(
                  icon: const Icon(Icons.text_fields),
                  onPressed: _showAddTextDialog),
              IconButton(icon: const Icon(Icons.image), onPressed: _addImage),
            ],
          ),
        ),
      ),
    );
  }
}

class CanvasPainter extends CustomPainter {
  final List<Offset> path;

  CanvasPainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.indigo
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < path.length - 1; i++) {
      canvas.drawLine(path[i], path[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
