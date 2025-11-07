import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luarsekolah/features/todo/data/models/todo.dart';
import 'package:luarsekolah/core/constants/app_colors.dart';

class AddTodoPage extends StatefulWidget {
  final Todo? todo;

  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  bool _isLoading = false;

  bool get _isEditing => widget.todo != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _textController.text = widget.todo!.text;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _saveTodo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final todo = Todo(
        id: _isEditing ? widget.todo!.id : null,
        text: _textController.text.trim(),
        completed: _isEditing ? widget.todo!.completed : false,
        createdAt: _isEditing ? widget.todo!.createdAt : null,
        updatedAt: _isEditing ? widget.todo!.updatedAt : null,
      );

      if (mounted) {
        Get.back(result: todo);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error:  ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Todo' : 'Tambah Todo',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.greenDecorative,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detail Todo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _textController,
                        decoration: InputDecoration(
                          labelText: 'Todo',
                          hintText: 'Masukkan todo yang ingin dikerjakan',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.greenDecorative,
                              width: 2,
                            ),
                          ),
                          prefixIcon: const Icon(Icons.task_alt),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Todo tidak boleh kosong';
                          }
                          if (value.trim().length > 500) {
                            return 'Todo maksimal 500 karakter';
                          }
                          return null;
                        },
                        maxLines: 3,
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveTodo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenDecorative,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(_isEditing ? Icons.save : Icons.add),
                            const SizedBox(width: 8),
                            Text(
                              _isEditing ? 'Simpan Perubahan' : 'Tambah Todo',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              if (_isEditing) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[400]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
