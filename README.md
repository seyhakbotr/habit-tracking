# Getting Started with Flutter

To run this project, you first need to set up your local development environment. If you don't already have Flutter installed, follow these steps:

1. **Install Flutter**: Visit the official Flutter website and follow the installation instructions for your operating system (Windows, macOS, or Linux). This includes downloading the Flutter SDK and setting up the necessary development tools.
2. **Configure Your Editor**: Use a code editor like Visual Studio Code or Android Studio. Both have excellent plugins for Flutter development.
3. **Check Your Setup**: Open a terminal or command prompt and run `flutter doctor`. This command checks your environment and shows you which tools are missing or need configuration. Follow the on-screen prompts to fix any issues.

Once Flutter is installed and configured, you can run the project by opening a terminal at the project's root and executing `flutter run`.

## Common Setup Errors and Solutions

### Error: Flutter command not found

**Solution**: Make sure Flutter is added to your system PATH. Restart your terminal/command prompt after installation.

### Error: Android toolchain issues

**Solution**: Run `flutter doctor --android-licenses` and accept all licenses. Ensure Android Studio and SDK are properly installed.

### Error: Xcode issues (macOS only)

**Solution**: Install Xcode from the Mac App Store and run `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`.

# Running the Project with Firebase

To use this project with Firebase, you'll need to link it to a new Firebase project.

## Step 1: Set up Firebase

1. **Create a New Project**: Go to the Firebase console and create a new project.
2. **Enable Authentication**: In the Firebase console, navigate to Authentication > Sign-in method. Enable the Email/Password provider and save your changes.
3. **Enable Cloud Firestore**: Go to Firestore Database and create a new database.

## Step 2: Connect Flutter to Firebase

You have two options for connecting your Flutter app to your new Firebase project.

### Option 1: Using the FlutterFire CLI (Recommended) 🚀

This is the easiest and most reliable method.

1. **Install CLIs**: Ensure you have the Firebase CLI and FlutterFire CLI installed on your machine.
2. **Log in**: From your project's root directory in the terminal, run `firebase login`. This will give the CLI access to your Firebase projects.
3. **Configure**: Run `flutterfire configure` and follow the on-screen prompts to select your Firebase project and set up the necessary files for each platform (iOS, Android, and web).

For more detailed information, refer to the official guide on [How to add Firebase to a Flutter app with the FlutterFire CLI](https://firebase.google.com/docs/flutter/setup).

#### Common FlutterFire CLI Errors and Solutions

### Error: Firebase CLI not found

**Solution**: Install Firebase CLI using `npm install -g firebase-tools` or download from the official Firebase website.

### Error: FlutterFire CLI not found

**Solution**: Install FlutterFire CLI using `dart pub global activate flutterfire_cli`.

### Error: Authentication failed

**Solution**: Run `firebase logout` then `firebase login` again. Ensure you're using the correct Google account.

### Error: Project not found during configuration

**Solution**: Verify your Firebase project exists and you have proper permissions. Check that you're logged into the correct Google account.

### Option 2: Manual Setup (Not Recommended)

If you prefer to connect your project manually, follow these steps for each platform.

#### For Android:

1. Register an Android app in your Firebase project settings using the package name `com.example.starter_architecture_flutter_firebase`.
2. Download the `google-services.json` file and copy it into the `android/app` directory of your project.

#### For iOS:

1. Register an iOS app in your Firebase project settings using the bundle ID `com.example.starterArchitectureFlutterFirebase`.
2. Download the `GoogleService-Info.plist` file.
3. In Xcode, open your project and add the `GoogleService-Info.plist` file to the `iOS/Runner` directory, ensuring it's added to the Runner target.

#### Common Manual Setup Errors and Solutions

### Error: Package name/Bundle ID mismatch

**Solution**: Ensure the package name in `android/app/build.gradle` matches the one registered in Firebase. For iOS, check the bundle identifier in `ios/Runner.xcodeproj/project.pbxproj`.

### Error: google-services.json not found

**Solution**: Verify the file is placed in `android/app/` directory (not in a subfolder) and the filename is exactly `google-services.json`.

### Error: GoogleService-Info.plist not properly added (iOS)

**Solution**: In Xcode, right-click on Runner folder > Add Files to "Runner" > Select the plist file > Ensure "Add to target" shows Runner is checked.

## Runtime Errors and Solutions

### Error: MissingPluginException

**Solution**: Run `flutter clean` then `flutter pub get`. If the error persists, try `flutter pub upgrade`.

### Error: Firebase not initialized

**Solution**: Ensure `Firebase.initializeApp()` is called in your `main()` function before `runApp()`.

### Error: Platform-specific configuration missing

**Solution**: Verify that configuration files are in the correct locations and run `flutterfire configure` again if using CLI setup.

Once you have completed these steps, you are all set! Have fun building. 🥳

# License

This project is released under the MIT License.
