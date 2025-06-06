plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.restoup_flutter"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "25.2.9519653"
   // ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.restoup_flutter"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // Ajouter la dépendance AppCompat pour Theme.AppCompat
    implementation 'androidx.appcompat:appcompat:1.7.0'
    // Ajouter la dépendance Material Components (optionnel, si tu veux utiliser Theme.MaterialComponents)
    implementation 'com.google.android.material:material:1.12.0'
    // Dépendances déjà ajoutées dans une réponse précédente
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'
    implementation 'org.jetbrains.kotlin:kotlin-stdlib:2.1.10'
    constraints {
        implementation('androidx.constraintlayout:constraintlayout') {
            version {
                strictly '2.1.4'
            }
        }
    }
}

flutter {
    source = "../.."
}
