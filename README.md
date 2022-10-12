# ChaseApp
## About
 ChaseApp notifications and chat application using Flutter and Firebase, where users can register and start conversing with each other.

## Configuration Steps
1. Cloning the repository:

```
$ git clone https://github.com/chase-app/chase-app.git
```

2. Open the project and install dependencies (using terminal):

```
$ cd chaseapp
$ flutter pub get
```
This installs all the required dependencies like cloud_firestore, shared_preferences, flutter_spinkit etc...

3. Make an android project on your firebase account, follow the mentioned steps and you're good to go.

4. Now run the app on your connected device (using terminal):

`$ flutter run`
=======
1. You need to get your SHA and SHA256 signing key from the output of 'gradlew signingReport'
2. Upload keys to the ChaseApp firebase project - https://console.firebase.google.com/u/0/project/chaseapp-8459b/settings/general/android:com.carverauto.chaseapp
3. Download the updated google-services.json and install into the chaseapp/android/app/ directory
5. Configure ~/.gradle/gradle.properties for Mapbox Secret Token

https://docs.mapbox.com/android/maps/guides/install/

Add

`MAPBOX_DOWNLOAD_TOKEN=<token>`

## App Store / App Connect

### Build

Supply the correct Pusher Instance ID and Stream Chat API key:

```
flutter build ipa --flavor prod --target lib/main_prod.dart --dart-define=Prod_Pusher_Instance_Id=4asdfasdf33 --dart-define=Prod_GetStream_Chat_Api_Key=sadfasdf
```

### Distribute

Open the build in xcode and hit distribute app

```
open /Users/mfreeman/src/flutter/build/ios/archive/Runner.xcarchive
```

## Github Actions CI/CD

To trigger the CI/CD workflow for store deployment for android and ios,
push a tagged commit with the latest version tag like follow,

```
git tag v0.1 -a -m "Release v0.1"
git push --follow-tags
```

### For Ios build : 

Flutter target Identifier: com.carverauto.chaseapp --> Production

AppImageNotification target Identifier: com.carverauto.chaseapp.AppImageNotification 

Profiles and certificates used for creating `Prod` release for above identifiers.

### Profiles:

Development Profile for target Flutter: `Chaseapp-prod`
Development Certificate used: Used any one of the dev certificate as the profile includes all of them.

Development Profile for target AppImageNotification: `AppImage`
Development Certificate used: Used any one of the dev certificate as the profile includes all of them.

Distribution Profile for target Flutter: `sep17-provisionProfile`
Distribution Certificate used: `2022/12/28`

Development Profile for target AppImageNotification: `wildcard`
Development Certificate used: `2022/12/28`

### Archive export: 

We are using manual signing and provisioning profiles are set likewise in the xcode. And the `flutter build ipa` command throws error when exporting archive when manual signing is used.
That's why we are providing `ExportOptions.plist` file which includes manual signing settings to use while exporting archive. If any changes are need to be made in export profiles, then updated ExportOptions.plist needs to be updated here.

ExportOptions.plist can be generated once by manually exporting the archive through xcode.

Steps :
 1. Build archive through `flutter build ipa ...other parameters`
 2. Open archive in xcode and export it.
 3. Copy updated ExportOptions.plist from the exported archive folder within build folder in project dir.



## Appcircle

### Custom Script

We need to change the Java version:

https://docs.appcircle.io/integrations/working-with-custom-scripts/custom-script-samples/

Create a custom script above the android build step with the shell script:

```shell
echo "Default JAVA "$JAVA_HOME
echo "OpenJDK 8 "$JAVA_HOME_8_X64
echo "OpenJDK 11 "$JAVA_HOME_11_X64

# Change JAVA_HOME to OPENJDK 11
echo "JAVA_HOME=$JAVA_HOME_11_X64" >> $AC_ENV_FILE_PATH
```
