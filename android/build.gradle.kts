// Top-level build file where you can add configuration options common to all sub-projects/modules.

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.3.0") // عدّل حسب نسخة Gradle عندك
        classpath("com.google.gms:google-services:4.4.3") // النسخة الوحيدة للـ Google Services
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// تعديل مجلد البناء ليكون خارج مجلد المشروع
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
