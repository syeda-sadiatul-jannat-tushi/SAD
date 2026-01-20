import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;

  late final Stream<List<Map<String, dynamic>>> _notesStream;
  late final AnimationController _animationController;

  // List of stars for background animation
  final List<_Star> _stars = List.generate(30, (index) => _Star());

  @override
  void initState() {
    super.initState();
    final userId = supabase.auth.currentUser!.id;
    _notesStream = supabase
        .from('notes')
        .stream(primaryKey: ['id'])
        .eq('uuid', userId);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // CRUD operations
  Future<void> _addNote() async {
    try {
      await supabase.from('notes').insert({
        'body': _controller.text,
        'uuid': supabase.auth.currentUser!.id,
      });
    } catch (e) {
      mySnackBar(context, e.toString());
    }
    _controller.clear();
  }

  Future<void> _updateNote(int noteId, String newContent) async {
    await supabase.from('notes').update({'body': newContent}).eq('id', noteId);
    _controller.clear();
  }

  Future<void> deleteNote(int noteId) async {
    await supabase.from('notes').delete().eq('id', noteId);
  }

  void mySnackBar(context, content) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(content)));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text("My Notes"),
        backgroundColor: Colors.pink[300],
      ),
      body: Stack(
        children: [
          // Pink star animation background
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                size: MediaQuery.of(context).size,
                painter: _StarPainter(_stars, _animationController.value),
              );
            },
          ),
          // Notes list
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: _notesStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    "No notes yet!",
                    style: TextStyle(fontSize: 18, color: Colors.pink),
                  ),
                );
              }
              final notes = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Card(
                    color: const Color.fromARGB(255, 203, 81, 122),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        note['body'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              _controller.text = note['body'];
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.pink[100],
                                  title: const Text("Update Note"),
                                  content: Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      controller: _controller,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Cannot be empty!";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.pink[300],
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _updateNote(
                                            note['id'],
                                            _controller.text,
                                          );
                                          mySnackBar(context, "Note updated!");
                                        }
                                      },
                                      child: const Text("Update"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.pink[100],
                                  title: const Text("Confirm Delete"),
                                  content: const Text(
                                    "Are you sure you want to delete this note?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                      ),
                                      onPressed: () {
                                        deleteNote(note['id']);
                                        mySnackBar(context, "Note deleted!");
                                      },
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink[300],
        onPressed: () {
          _controller.clear();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.pink[100],
              title: const Text("Add a Note"),
              content: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _controller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[300],
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _addNote();
                      mySnackBar(context, "Note Added!");
                    }
                  },
                  child: const Text("Add"),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Star model
class _Star {
  double x = Random().nextDouble();
  double y = Random().nextDouble();
  double size = Random().nextDouble() * 3 + 2;
  double speed = Random().nextDouble() * 0.5 + 0.2;
}

// Star painter
class _StarPainter extends CustomPainter {
  final List<_Star> stars;
  final double progress;

  _StarPainter(this.stars, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.pinkAccent.withOpacity(0.7);
    for (var star in stars) {
      final dx = star.x * size.width;
      final dy = ((star.y + progress * star.speed) % 1) * size.height;
      canvas.drawCircle(Offset(dx, dy), star.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
