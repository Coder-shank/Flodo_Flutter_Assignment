# Flutter Task Manager

A **modern task management app** built with **Flutter** and **Provider**, designed to help users efficiently manage, prioritize, and track their tasks. This project demonstrates clean state management, responsive UI, and interactive features like drag-and-drop reordering with persistent storage simulation.

---

## **Features**

### 1. Task Management
- **Add, Edit, Delete tasks** with ease.
- **Task attributes**:
  - Title
  - Description
  - Due date
  - Status: To-Do, In Progress, Done
  - Blocked By: Link tasks that depend on others

### 2. Drag-and-Drop Reordering
- Users can **reorder tasks** by dragging and dropping them.
- **Custom task order persists** across app restarts.
- Reordering **updates the backend state** (simulated in this project with in-memory storage).

### 3. Loading & Delay Simulation
- **2-second delay** on task creation and updates to simulate real-world network calls.
- Shows a **loading indicator** during this delay.
- Prevents **duplicate submissions** by disabling the save button.

### 4. Search and Filter
- **Search** tasks by title or description.
- **Filter** tasks by status: To-Do, In Progress, Done, or All.

### 5. UI & UX
- Clean, minimal, and responsive design.
- Left panel: Task list with **search, filter, and drag-and-drop**.
- Right panel: **Task creation/editing form**.
- **Blocked tasks are visually greyed out**, making it easy to track dependencies.

### 6. Persistent Input State
- Typed but unsaved input **remains in the form** if the user navigates away and returns.
  
## **Tech Stack**

- **Flutter** – Frontend framework
- **Provider** – State management
- **Dart** – Programming language

  ## Screenshots:
  https://docs.google.com/document/d/1jh6QDbu4bijFkZMKUOI-dFR6GqIeeE7ceeWw_d4ZSmU/edit?tab=t.0
    
  


## **Getting Started**

### **Prerequisites**
- Flutter SDK installed
- An IDE like Android Studio, VS Code, or IntelliJ
- Device or emulator to run the app

### **Installation Steps**

1. Clone the repository:

```bash
gh repo clone Coder-shank/Flodo_Flutter_Assignment

2. Navigate into the project folder:

```bash
cd flutter-task-manager

3.Get dependencies

```bash
flutter pub get

4.Run the app

```bash
flutter run


** I choosed Track-B  **

**AI Usage Report – ChatGPT

Date: April 3, 2026
User: Shashank Pandey

Summary

Today, AI assistance was extensively utilized to support Flutter development, task management app debugging, and feature implementation. The interaction primarily focused on code review, bug fixing, and enhancing app functionality for better UX and reliability.

Areas of Usage
1. Flutter Task Management App
Debugging main.dart:
Fixed null-safety issues and type mismatches.
Implemented proper async handling for task creation and updates.
Ensured UI does not freeze during operations by adding loading states.
Task Reordering & Filtering:
Added functionality to reorder tasks via ReorderableListView.
Implemented search and filter features for task lists.
Task Form Enhancements:
Added "Blocked By" option with correct handling of None values.
Simulated 2-second delay for adding/editing tasks with button loading states.
Maintained draft input values when the user navigates away.
UI Improvements:
Ensured blocked tasks display with opacity changes.
Improved task card design and due date formatting.
2. Code Quality & Best Practices
Applied null safety for all fields and dropdowns.
Avoided UI freezes using Future.delayed for asynchronous operations.
Ensured automatic state persistence using AutomaticKeepAliveClientMixin.
Structured the code for maintainability with reusable widgets like taskCard and showEditDialog.
3. Learning and Documentation
Learned proper handling of nullable fields in Dart.
Learned to simulate async operations without freezing Flutter UI.
Documented AI-assisted development workflow to enhance project README.
Tools Used
ChatGPT (GPT-5 Mini): Assisted in debugging, code review, and feature implementation.
Flutter & Dart: Mobile app development.
Provider: State management for task app.
Outcomes
Fully functional task management app with task creation, editing, deletion, filtering, search, and reordering.
Improved user experience with loading states and blocked task handling.
Enhanced code quality, null safety, and maintainability.






