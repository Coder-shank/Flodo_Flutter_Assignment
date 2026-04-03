import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'models/task.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final dateController = TextEditingController();

  String status = "To-Do";
  String? blockedBy;
  bool isLoading = false; // ✅ Loading state for button
  String selectedFilter = "All";
  String searchQuery = "";

  String tempTitle = "";
  String tempDesc = "";
  String tempDate = "";

  @override
  void initState() {
    super.initState();

    titleController.addListener(() {
      tempTitle = titleController.text;
    });

    descController.addListener(() {
      tempDesc = descController.text;
    });

    dateController.addListener(() {
      tempDate = dateController.text;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final provider = Provider.of<TaskProvider>(context);

    // Apply search & filter
    List<Task> tasks = provider.tasks.where((task) {
      final matchesSearch = task.title
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          task.description
              .toLowerCase()
              .contains(searchQuery.toLowerCase());

      final matchesFilter =
          selectedFilter == "All" || task.status == selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // LEFT SIDE
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text("Task Manager",
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold)),

                        SizedBox(height: 20),

                        // SEARCH & FILTER ROW
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: SizedBox(
                                height: 45,
                                child: TextField(
                                  onChanged: (val) {
                                    setState(() => searchQuery = val);
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Search tasks...",
                                    border: OutlineInputBorder(),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 10),

                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                height: 45,
                                child: DropdownButtonFormField<String>(
                                  value: selectedFilter,
                                  isExpanded: true,
                                  items: [
                                    "All",
                                    "To-Do",
                                    "In Progress",
                                    "Done"
                                  ]
                                      .map((e) => DropdownMenuItem(
                                          value: e, child: Text(e)))
                                      .toList(),
                                  onChanged: (val) {
                                    setState(() => selectedFilter = val!);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 25),

                        // DRAGGABLE TASK LIST
                        Container(
                          width: double.infinity,
                          child: ReorderableListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: tasks.asMap().entries.map((entry) {
                              int index = entry.key;
                              Task task = entry.value;

                              bool isBlocked = task.blockedBy != null &&
                                  provider.tasks.any((t) =>
                                      t.title == task.blockedBy &&
                                      t.status != "Done");

                              return Container(
                                key: ValueKey(task.title + task.dueDate.toString()),
                                child: taskCard(task, index, isBlocked),
                              );
                            }).toList(),
                            onReorder: (oldIndex, newIndex) async {
                              if (newIndex > oldIndex) newIndex -= 1;
                              await provider.reorderTask(oldIndex, newIndex);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(width: 40),

              // RIGHT FORM
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text("Add Task",
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold)),

                        SizedBox(height: 20),

                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(labelText: "Title"),
                        ),

                        TextField(
                          controller: descController,
                          decoration:
                              InputDecoration(labelText: "Description"),
                        ),

                        SizedBox(height: 10),

                        TextField(
                          controller: dateController,
                          readOnly: true,
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );

                            if (picked != null) {
                              dateController.text =
                                  picked.toString().split(" ")[0];
                            }
                          },
                          decoration:
                              InputDecoration(labelText: "Select Date"),
                        ),

                        SizedBox(height: 10),

                        DropdownButtonFormField<String>(
                          value: status,
                          items: ["To-Do", "In Progress", "Done"]
                              .map((e) => DropdownMenuItem(
                                  value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) {
                            setState(() => status = val!);
                          },
                        ),

                        SizedBox(height: 10),

                        DropdownButtonFormField<String>(
                          hint: Text("Blocked By"),
                          value: blockedBy,
                          items: [
                            DropdownMenuItem<String>(
                              value: "None",
                              child: Text("None"),
                            ),
                            ...provider.tasks.map((task) =>
                                DropdownMenuItem<String>(
                                  value: task.title,
                                  child: Text(task.title),
                                ))
                          ],
                          onChanged: (val) {
                            setState(() {
                              blockedBy = val == "None" ? null : val;
                            });
                          },
                        ),

                        SizedBox(height: 20),

                        // ✅ Save button with 2-second simulated delay
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            onPressed: isLoading
                                ? null
                                : () async {
                                    if (titleController.text.isEmpty) return;

                                    // Show loading and prevent double-tap
                                    setState(() => isLoading = true);

                                    // Simulate 2-second delay without freezing UI
                                    await Future.delayed(Duration(seconds: 2));

                                    // Add task
                                    provider.addTask(
                                      Task(
                                        title: titleController.text,
                                        description: descController.text,
                                        dueDate: DateTime.tryParse(
                                                dateController.text) ??
                                            DateTime.now(),
                                        status: status,
                                        blockedBy: blockedBy,
                                      ),
                                    );

                                    // Clear form
                                    titleController.clear();
                                    descController.clear();
                                    dateController.clear();

                                    tempTitle = "";
                                    tempDesc = "";
                                    tempDate = "";

                                    setState(() {
                                      isLoading = false;
                                      blockedBy = null;
                                      status = "To-Do";
                                    });
                                  },
                            child: isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text("Save"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget taskCard(Task task, int index, bool blocked) {
    final provider = Provider.of<TaskProvider>(context, listen: false);

    Color statusColor = task.status == "To-Do"
        ? Colors.orange
        : task.status == "In Progress"
            ? Colors.blue
            : Colors.green;

    return Opacity(
      opacity: blocked ? 0.4 : 1,
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(task.title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),

                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showEditDialog(context, index, task);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        provider.deleteTask(index);
                      },
                    ),
                  ],
                )
              ],
            ),

            SizedBox(height: 10),
            Text(task.description),
            SizedBox(height: 15),

            Row(
              children: [
                Text("Due: ${task.dueDate.day}/${task.dueDate.month}"),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(task.status,
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),

            if (blocked)
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Blocked by: ${task.blockedBy}",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ✅ Edit dialog with 2-second simulated delay
  void showEditDialog(BuildContext context, int index, Task task) {
    final provider = Provider.of<TaskProvider>(context, listen: false);

    final titleCtrl = TextEditingController(text: task.title);
    final descCtrl = TextEditingController(text: task.description);
    final dateCtrl =
        TextEditingController(text: task.dueDate.toString().split(" ")[0]);

    String status = task.status;
    String? blockedBy = task.blockedBy;
    bool isUpdating = false; // Prevent double-tap

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Edit Task"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    TextField(controller: titleCtrl),
                    TextField(controller: descCtrl),

                    SizedBox(height: 10),

                    TextField(
                      controller: dateCtrl,
                      readOnly: true,
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: task.dueDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );

                        if (picked != null) {
                          setState(() {
                            dateCtrl.text = picked.toString().split(" ")[0];
                          });
                        }
                      },
                    ),

                    SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: status,
                      items: ["To-Do", "In Progress", "Done"]
                          .map((e) => DropdownMenuItem(
                              value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        setState(() => status = val!);
                      },
                    ),

                    SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      hint: Text("Blocked By"),
                      value: blockedBy,
                      items: [
                        DropdownMenuItem<String>(
                          value: "None",
                          child: Text("None"),
                        ),
                        ...provider.tasks.map((t) =>
                            DropdownMenuItem<String>(
                              value: t.title,
                              child: Text(t.title),
                            ))
                      ],
                      onChanged: (val) {
                        setState(() {
                          blockedBy = val == "None" ? null : val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isUpdating
                      ? null
                      : () async {
                          setState(() => isUpdating = true);

                          // 2-second delay for update
                          await Future.delayed(Duration(seconds: 2));

                          provider.updateTask(
                            index,
                            Task(
                              title: titleCtrl.text,
                              description: descCtrl.text,
                              dueDate:
                                  DateTime.tryParse(dateCtrl.text) ?? task.dueDate,
                              status: status,
                              blockedBy: blockedBy,
                            ),
                          );
                          Navigator.pop(context);
                        },
                  child: isUpdating
                      ? CircularProgressIndicator()
                      : Text("Save"),
                )
              ],
            );
          },
        );
      },
    );
  }
}