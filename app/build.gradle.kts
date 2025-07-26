plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
    alias(libs.plugins.ksp)
    alias(libs.plugins.kotlinx.serialization)

    alias(libs.plugins.gms)
    alias(libs.plugins.crashlytics)
}

val gitHash = execute("git", "rev-parse", "--short", "HEAD")
val gitCount = execute("git", "rev-list", "--count", "HEAD").toInt()
val version = "0.0.6"

android {
    namespace = "dev.brahmkshatriya.echo"
    compileSdk = 35

    defaultConfig {
        applicationId = "dev.weier.spotifix"
        minSdk = 24
        targetSdk = 35
        versionCode = gitCount
        versionName = "v${version}_$gitHash($gitCount)"
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
            )
        }
        create("nightly") {
            initWith(getByName("release"))
            applicationIdSuffix = ".nightly"
            resValue("string", "app_name", "Spotifix Nightly")
        }
        create("stable") {
            initWith(getByName("release"))
        }
    }

    buildFeatures {
        buildConfig = true
        viewBinding = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    androidResources {
        @Suppress("UnstableApiUsage")
        generateLocaleConfig = true
    }
}

dependencies {
    implementation(project(":common"))
    implementation(libs.kotlin.reflect)
    implementation(libs.bundles.androidx)
    implementation(libs.material)
    implementation(libs.bundles.paging)
    implementation(libs.bundles.room)
    ksp(libs.room.compiler)
    implementation(libs.bundles.koin)
    implementation(libs.bundles.media3)
    implementation(libs.bundles.coil)

    implementation(libs.pikolo)
    implementation(libs.fadingedgelayout)
    implementation(libs.fastscroll)
    implementation(libs.kenburnsview)
    implementation(libs.nestedscrollwebview)
    implementation(libs.acsbendi.webview)

    debugImplementation(libs.bundles.firebase)
    "stableImplementation"(libs.bundles.firebase)
    "nightlyImplementation"(libs.bundles.firebase)
}

fun execute(vararg command: String): String {
    val process = ProcessBuilder(*command)
        .redirectOutput(ProcessBuilder.Redirect.PIPE)
        .redirectError(ProcessBuilder.Redirect.PIPE)
        .start()
    val output = process.inputStream.bufferedReader().readText()
    val errorOutput = process.errorStream.bufferedReader().readText()
    val exitCode = process.waitFor()
    if (exitCode != 0) throw Exception(
        """
        Command failed with exit code $exitCode. 
        Command: ${command.joinToString(" ")}
        Stdout: $output
        Stderr: $errorOutput
        """.trimIndent()
    )
    return output.trim()
}
