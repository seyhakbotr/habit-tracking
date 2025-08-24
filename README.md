# Getting Started with Flutter

To run this project, you first need to set up your local development environment. If you don't already have Flutter installed, follow these steps:

    Install Flutter: Visit the official Flutter website and follow the installation instructions for your operating system (Windows, macOS, or Linux). This includes downloading the Flutter SDK and setting up the necessary development tools.

    Configure Your Editor: Use a code editor like Visual Studio Code or Android Studio. Both have excellent plugins for Flutter development.

    Check Your Setup: Open a terminal or command prompt and run flutter doctor. This command checks your environment and shows you which tools are missing or need configuration. Follow the on-screen prompts to fix any issues.

Once Flutter is installed and configured, you can run the project by opening a terminal at the project's root and executing flutter run.

# Running the Project with Firebase

To use this project with Firebase, you'll need to link it to a new Firebase project.

Step 1: Set up Firebase

    Create a New Project: Go to the Firebase console and create a new project.

    Enable Authentication: In the Firebase console, navigate to Authentication > Sign-in method. Enable the Email/Password provider and save your changes.

    Enable Cloud Firestore: Go to Firestore Database and create a new database.

Step 2: Connect Flutter to Firebase

You have two options for connecting your Flutter app to your new Firebase project.

Option 1: Using the FlutterFire CLI (Recommended) 🚀

This is the easiest and most reliable method.

    Install CLIs: Ensure you have the Firebase CLI and FlutterFire CLI installed on your machine.

    Log in: From your project's root directory in the terminal, run firebase login. This will give the CLI access to your Firebase projects.

    Configure: Run flutterfire configure and follow the on-screen prompts to select your Firebase project and set up the necessary files for each platform (iOS, Android, and web).

For more detailed information, refer to the official guide on How to add Firebase to a Flutter app with the FlutterFire CLI.

Option 2: Manual Setup (Not Recommended)

If you prefer to connect your project manually, follow these steps for each platform.

For Android:

    Register an Android app in your Firebase project settings using the package name com.example.starter_architecture_flutter_firebase.

    Download the google-services.json file and copy it into the android/app directory of your project.

For iOS:

    Register an iOS app in your Firebase project settings using the bundle ID com.example.starterArchitectureFlutterFirebase.

    Download the GoogleService-Info.plist file.

    In Xcode, open your project and add the GoogleService-Info.plist file to the iOS/Runner directory, ensuring it's added to the Runner target.

Once you have completed these steps, you are all set! Have fun building. 🥳

# License

This project is released under the MIT License.
