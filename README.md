# Sorttasks

## Description
This project is a mobile application developed to facilitate personal and professional task management, allowing users to track and organize their commitments and deadlines. With a focus on usability, security, and productivity, the app provides an intuitive interface with support for light and dark themes, ensuring a pleasant and efficient user experience.

## Features
The application includes a variety of essential features for task management, such as:
* User Authentication: Secure registration and login for access to app features.
* Password Recovery: Option to recover the user’s password.
* Task Management: Access to pending tasks, task history, task addition, and editing.
* Customizable Sorting and Filtering: Ability to sort and filter tasks based on priority and deadlines.
* Task Notifications: Reminders for tasks with upcoming deadlines.
* User Profile: View and update personal information.

## Requirements

### Functional Requirements
* Authentication and Session Management: Account creation, login, and password recovery.
* Task Management: Create, edit, delete, and mark tasks as completed.
* Customizable View: Sort and filter tasks by priority and due date.
* Notifications: Alerts for upcoming deadlines.
* Profile Management: View and update personal information.

### Non-functional Requirements
* Security: Secure storage of user data.
* Usability: Intuitive, responsive interface with light and dark theme support.
* Scalability: Architecture that allows future expansion with more features.
* Availability: Available on multiple devices with data synchronization.
* Maintainability: Code written with standards to facilitate maintenance and future development.

## Architecture
The project's architecture consists of several classes and services organized to maximize modularity and scalability:
* User Auth: Responsible for user authentication, including account creation, login, and password recovery.
* User: Class that stores user information and handles task creation and management.
* User Storage: Manages storage of personal data, such as the profile picture.
* Task: Main class for task management, with properties such as title, description, priority, and creation date.
* Notification Service: Service to create notifications for tasks with upcoming deadlines.
* Unfinished Task / Archived Task: Represents pending and archived tasks, respectively, with methods to automatically check and archive tasks.

## Technologies Used
* Dart (83%): Main language used for app development.
* C++ (8.3%) and CMake (6.5%): Used for integrating specific functionalities.
* Swift (0.9%) and HTML (0.6%): For additional features and user interface.

## Installation and Running
1. Set Up an Android Virtual Device:
* Download and install Android Studio.
* Open Android Studio, go to Configure > AVD Manager.
* **[RECOMMENDED]** Click Create Virtual Device and select Pixel XL as the device
* **[RECOMMENDED]** Choose API Level 33 as the system image, then follow the prompts to finish the setup.
* Once set up, you can start the virtual device from the AVD Manager.
2. Install Flutter SDK, as this will cover all pre-requirements. You can do that by following the instructions on the [official Flutter website](https://docs.flutter.dev/get-started/install).
3. Clone the repository:
```
git clone https://github.com/daniel-nunes-03/sorttasks.git
cd sorttasks
```
4. Install Dependencies: Run the following command to install all necessary dependencies as specified in `pubspec.yaml`:
```
dart pub upgrade
```
5. Run the project with:
```
flutter run
```
