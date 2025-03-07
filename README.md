<<<<<<< HEAD
# taskmanager

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
=======
# glidix_taskmnger
Task Managemnet Application
>>>>>>> 92097bb5c88f9be10d1b45c1d4eb106e4702f571
Used Libraries : lottie //for adding asset gif Animations
connectivity_plus : checking internet
flutter_slidable : Slide ListTile for better UI
sqflite/objectbox : localdb
flutter_bounce  :for Button bouncing when clicking
wave : for wave animation
intl : Dateformate
cloud_firestore/firebase_core : firebase integration and cloud firestore
path_provider :to set path of imported data for Sqlite
provider :statemangemnet
>>>>>>>>
HOME SCREEN(Task manager)
------------------------
-its offline-first design project,
-Added  offline/online status indicator if its Online it will show Green color circle 
 in Offline it will Show Red Circle 
-Offline AlertBox Will displayed When App in Offline Mode
-For Adding New Task=>  Press Floating Action Button(+) it will show Some Field ,After fill The field Press Save Button Redirect to
HomePage , IT CAN Show list of Task with Wave Animation
Task with approaching deadlines (e.g., within 24 hours) it will display a warning icon
The task are overdue it Added seperate List section with Error Icon the Head is isOverdueTask ,
else without overdue task it will show inside Upcoming task with green check icon ,
 if the deadline is within 24 hours added seperate Warning icon 
also added seperate wave color based on Priority
Sync task with Firebase Firestore when the app is online ,Only Completed Task move to Firestore
Also Added Export and Import Task Functionality  for using Sqlite database  stored locally.(Arrow Down =Import and Arrow Up=Export)


=========For The delete/edit Task-------------
inside TaskManger Page,
Slide the ListTile from Right to Left it will show edit and delete Button then easy to edit or delete the task

