import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "net.forhimandus.oracledasgard"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "net.forhimandus.oracledasgard"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    
    signingConfigs {
        create("release") {
            val keyAliasFromEnv = System.getenv("ANDROID_KEYSTORE_ALIAS")
            val keyPasswordFromEnv = System.getenv("ANDROID_KEYSTORE_PASSWORD")
            val storePasswordFromEnv = System.getenv("ANDROID_KEYSTORE_STORE_PASSWORD")
            val keystorePathFromEnv = System.getenv("KEYSTORE_PATH")

            // Prioritize environment variables (from GitHub Secrets) over key.properties
            keyAlias = keyAliasFromEnv ?: (keystoreProperties["keyAlias"] as String?)
            keyPassword = keyPasswordFromEnv ?: (keystoreProperties["keyPassword"] as String?)
            storePassword = storePasswordFromEnv ?: (keystoreProperties["storePassword"] as String?)

            if (keystorePathFromEnv != null) {
                storeFile = file(keystorePathFromEnv)
            } else {
                storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            }

            // Explicitly check for null/empty values and fail early with clear messages
            if (keyAlias.isNullOrEmpty()) {
                throw GradleException("Signing key alias (ANDROID_KEYSTORE_ALIAS or keyAlias in key.properties) not specified.")
            }
            if (keyPassword.isNullOrEmpty()) {
                throw GradleException("Signing key password (ANDROID_KEYSTORE_PASSWORD or keyPassword in key.properties) not specified.")
            }
            if (storePassword.isNullOrEmpty()) {
                throw GradleException("Signing store password (ANDROID_KEYSTORE_STORE_PASSWORD or storePassword in key.properties) not specified.")
            }
            if (storeFile == null || !storeFile!!.exists()) {
                throw GradleException("Signing keystore file (KEYSTORE_PATH or storeFile in key.properties) not found or specified.")
            }
        }
    }
    
    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
dependencies {
    // ...
    implementation("com.google.android.material:material:1.12.0")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    // ...
}

flutter {
    source = "../.."
}
