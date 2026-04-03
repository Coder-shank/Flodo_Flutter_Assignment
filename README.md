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
- 
## **Tech Stack**

- **Flutter** – Frontend framework
- **Provider** – State management
- **Dart** – Programming language

---

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



