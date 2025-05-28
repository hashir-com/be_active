import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';
import 'package:thryv/services/hive_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final HiveService _hiveService = HiveService();
  UserModel? user;

  // Each workout has title, desc, and list of image paths
  List<Map<String, dynamic>> workouts = [];
  List<Map<String, String>> diets = [];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    user = _hiveService.getUser();

    if (user != null) {
      // Load workouts - previously a string, now parse into structure
      // Assuming you saved workoutPlan as before (title: desc\n\n...)
      // but now images must be loaded separately - you need to adapt your model accordingly.
      // For demo, let's assume you added workoutImages saved in user model as List<List<String>> matching workouts
      workouts =
          (user!.workoutPlan?.isNotEmpty ?? false)
              ? user!.workoutPlan!.split('\n\n').asMap().entries.map((entry) {
                final parts = entry.value.split(': ');
                return {
                  "title": parts[0],
                  "desc": parts.length > 1 ? parts[1] : "",
                  "images":
                      (user!.workoutImages != null &&
                              user!.workoutImages!.length > entry.key)
                          ? List<String>.from(user!.workoutImages![entry.key])
                          : <String>[],
                };
              }).toList()
              : [];

      diets =
          (user!.dietPlan?.isNotEmpty ?? false)
              ? user!.dietPlan!.split('\n\n').map((e) {
                final parts = e.split(': ');
                return {
                  "title": parts[0],
                  "desc": parts.length > 1 ? parts[1] : "",
                };
              }).toList()
              : [];
    }
  }

  Future<void> _pickImages(List<String> imagesList) async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        imagesList.addAll(pickedFiles.map((xfile) => xfile.path));
      });
    }
  }

  void _addItemDialog(String type) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    List<String> pickedImages = [];

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setStateDialog) {
              return AlertDialog(
                title: Text("Add $type"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: "Title"),
                      ),
                      TextField(
                        controller: descController,
                        decoration: const InputDecoration(
                          labelText: "Instructions",
                        ),
                        maxLines: 3,
                      ),
                      if (type == "Workout") ...[
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Add Images",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ...pickedImages.map(
                              (path) => Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Image.file(
                                    File(path),
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setStateDialog(() {
                                        pickedImages.remove(path);
                                      });
                                    },
                                    child: const CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final List<XFile>? newFiles =
                                    
                                    
                                    await _picker.pickMultiImage();
                                if (newFiles != null && newFiles.isNotEmpty) {
                                  setStateDialog(() {
                                    pickedImages.addAll(
                                      newFiles.map((x) => x.path),
                                    );
                                  });
                                }
                              },
                              child: Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[300],
                                child: const Icon(Icons.add),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (titleController.text.trim().isEmpty) {
                        // Simple validation
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a title')),
                        );
                        return;
                      }
                      final item = {
                        "title": titleController.text.trim(),
                        "desc": descController.text.trim(),
                        "images": pickedImages,
                      };
                      setState(() {
                        if (type == "Workout") {
                          workouts.add(
                            item,
                          ); // assuming item is valid workout data
                        } else {
                          if (item["title"] != null && item["desc"] != null) {
                            diets.add({
                              "title": item["title"] as String,
                              "desc": item["desc"] as String,
                            });
                          } else {
                            print("Invalid diet item: $item");
                          }
                        }
                      });

                      Navigator.pop(context);
                    },
                    child: const Text("Add"),
                  ),
                ],
              );
            },
          ),
    );
  }

  void _deleteItem(String type, int index) {
    setState(() {
      if (type == "Workout") {
        workouts.removeAt(index);
      } else if (type == "Diet") {
        diets.removeAt(index);
      }
    });
  }

  void _deleteWorkoutImage(int workoutIndex, int imageIndex) {
    setState(() {
      workouts[workoutIndex]["images"].removeAt(imageIndex);
    });
  }

  void _savePlans() {
    if (user == null) return;

    user!.workoutPlan = workouts
        .map((e) => "${e['title']}: ${e['desc']}")
        .join("\n\n");

    user!.workoutImages =
        workouts.map<List<String>>((e) {
          final List<dynamic>? imgs = e['images'];
          return imgs != null ? imgs.cast<String>().toList() : <String>[];
        }).toList();

    user!.dietPlan = diets
        .map((e) => "${e['title']}: ${e['desc']}")
        .join("\n\n");

    user!.save();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Plans & media saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Admin Panel")),
        body: Center(
          child: Text('No user found', style: theme.textTheme.headlineMedium),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Panel")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("User Info", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 10),
              _infoRow("Name", user!.name),
              _infoRow("Age", user!.age.toString()),
              _infoRow("Gender", user!.gender),
              _infoRow("BMI", user!.bmi?.toStringAsFixed(1) ?? 'N/A'),
              _infoRow(
                "Goal",
                userGoalToString(user!.goal ?? UserGoal.weightGain),
              ),
              const SizedBox(height: 24),

              _sectionHeader("Workout Plan", "Workout"),
              _workoutList(),
              const SizedBox(height: 16),

              _sectionHeader("Diet Plan", "Diet"),
              _itemList(diets, "Diet"),
              const SizedBox(height: 24),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF040B90),
                  ),
                  onPressed: _savePlans,
                  child: Text(
                    "Save Suggestions & Media",
                    style: GoogleFonts.roboto(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, String type) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            _addItemDialog(type);
          },
        ),
      ],
    );
  }

  Widget _itemList(List<Map<String, String>> items, String type) {
    if (items.isEmpty) {
      return Text("No $type items added.");
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          child: ListTile(
            title: Text(item["title"] ?? ""),
            subtitle: Text(item["desc"] ?? ""),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _deleteItem(type, index),
            ),
          ),
        );
      },
    );
  }

  Widget _workoutList() {
    if (workouts.isEmpty) {
      return const Text("No Workout items added.");
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];
        final images = workout["images"] as List<String>? ?? [];

        return Card(
          child: ExpansionTile(
            title: Text(workout["title"] ?? ""),
            subtitle: Text(workout["desc"] ?? ""),
            children: [
              if (images.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("No images added."),
                )
              else
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, imgIndex) {
                      final imgPath = images[imgIndex];
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              File(imgPath),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: GestureDetector(
                              onTap: () => _deleteWorkoutImage(index, imgIndex),
                              child: const CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text("Add Images"),
                  onPressed: () async {
                    await _pickImages(workouts[index]["images"]);
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _deleteItem("Workout", index),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
