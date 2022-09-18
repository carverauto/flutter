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
