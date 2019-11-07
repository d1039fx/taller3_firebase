# taller3_firebase

A new Flutter application.
hay un error que posiblemente se corriga en futuras actualizacion el cual no permite ejecutar el app por problemas de codigo ASCII lo que se debe es que el archivo android/app/build.gradle cambiar ext.kotlin_version = '1.2.71' por ext.kotlin_version = '1.3.50' y classpath 'com.android.tools.build:gradle:3.2.1' por classpath 'com.android.tools.build:gradle:3.5.0' y en archivo android/gradle/wrapper/gradle-wrapper.properties cambiar distributionUrl=https\://services.gradle.org/distributions/gradle-4.10.2-all.zip a distributionUrl=https\://services.gradle.org/distributions/gradle-5.6.2-all.zip

si hay problemas con androidX y firebase auth se debe poner android.useAndroidX=true y android.enableJetifier=true en gradle.properties

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
