import 'dart:io';

void main() {
  List<String> tasks = [];

  while (true) {
    print("\n===== TO-DO APPLICATION =====");
    print("1. Add Task");
    print("2. Remove Task");
    print("3. View Tasks");
    print("4. Exit");
    stdout.write("Enter your choice: ");
    String? choice = stdin.readLineSync();

    if (choice == '1') {
      stdout.write("Enter task to add: ");
      String? task = stdin.readLineSync();
      if (task != null && task.isNotEmpty) {
        tasks.add(task);
        print("Task added successfully!");
      } else {
        print("Task cannot be empty!");
      }

    } else if (choice == '2') {
      if (tasks.isEmpty) {
        print("No tasks to remove!");
      } else {
        print("Your Tasks:");
        for (int i = 0; i < tasks.length; i++) {
          print("${i + 1}. ${tasks[i]}");
        }
        stdout.write("Enter task number to remove: ");
        int index = int.parse(stdin.readLineSync()!) - 1;

        if (index >= 0 && index < tasks.length) {
          print("Removed: ${tasks[index]}");
          tasks.removeAt(index);
        } else {
          print("Invalid task number!");
        }
      }

    } else if (choice == '3') {
      if (tasks.isEmpty) {
        print("No tasks available!");
      } else {
        print("Your Tasks:");
        for (int i = 0; i < tasks.length; i++) {
          print("${i + 1}. ${tasks[i]}");
        }
      }

    } else if (choice == '4') {
      print("Exiting To-Do App. Goodbye!");
      break;

    } else {
      print("Invalid choice! Please try again.");
    }
  }
}
