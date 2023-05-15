# DFChat

A flutter application demonstrating integration of djangoflow_chat and [django-df-chat](https://github.com/djangoflow/django-df-chat)

This example uses [flutter_chat_ui](https://pub.dev/packages/flutter_chat_ui) as the Chat UIKIT, but `djangoflow_chat` can be integrated with other flutter chat related UIKITs as well.

## BEFORE RUNNING THE APP TODO

- [x] Install and run local backend server for [django-df-chat](https://github.com/djangoflow/django-df-chat), please follow steps in [README](https://github.com/djangoflow/djangoflow-examples/tree/main/simple_chat/backend-django#readme) to run the example backend for django. **It is very important to [create superusers](https://github.com/djangoflow/djangoflow-examples/tree/main/simple_chat/backend-django#readme) to login via the email, password in this example app.**
- [x] Generate OpenAPI client repository from local server by using the following command `sh ./tools/generate-openapi.sh -l` and this will create a `openapi` package in [openapi package](../openapi/) directory. Add `openapi` package in `pubspec.yaml`, Also make sure you've added `openapi` package in `dependency_overrides:` section to override it. (Note: You must re-generate this everytime schema/endpoint changes from backend/server side)
- [x] Generate api_repository,freezed, json_serializable, auto_route etc files `cd packages/chat && flutter pub run build_runner build --delete-conflicting-outputs` (you must regenerate this whenever openapi changes)
- [x] Follow TODO comments for [auth_cubit.dart](packages/chat/lib/features/authentication/blocs/auth_cubit.dart)

## Other TODO(Optional)

- [ ] Configure firebase using `flutterfire configure` in `packages/chat` directory. More info: https://pub.dev/packages/flutterfire_cli
- [ ] Update fastlane .env files in `packages/chat/android/fastlane` and `packages/chat/ios/fastlane` following the `sample.env.txt` file.
- [ ] Grant repository rights in github so that firebase setup works.
- [ ] Update firebase deployment target and setup. To do so, run `firebase init hosting`. After completing the steps a `firebase.json` will be generated. A generated `example_firebase.json` file will be generated already. More information: https://firebase.google.com/docs/hosting/quickstart After setup, please modify the `firebase.json` file with the example one(modify `target`s mostly). For `target` names, dev webapp should have `None-dev` and production `None-prod` as target names. And site-id is the first part of the domain. For example: `example.web.app` here `example` is the site-id. Follow this link for more information: https://firebase.google.com/docs/cli/targets#set-up-deploy-target-hosting After that a `.firebaserc` file will be generated with the target information. After that you can deploy and see if deployment works for both prod and dev. If you see "HTTP Error: 404, Requested entity was not found." that means the site-id associated with the target doesn't exist. In that case, new site can be generated by `firebase hosting:sites:create your-site-id` command. After that try `firebase deploy --only hosting:your-target-name` then it should deploy to the target.
- [ ] Update github workflows file, see [web deployment](#web-app-deployment)
- [ ] Update Smart App Banner for web app after app was deployed on appstore. In `packages/chat/web/index.html` find line with `<meta name="apple-itunes-app" content="app-id=appStoreID">`, here uncomment it and replace `appStoreID` with actual app store id for the app.
- [ ] Integrate https://pub.dev/packages/djangoflow_fcm package if need firebase_messaging functionality.
- [ ] Integrate https://pub.dev/packages/djangoflow_analytics and https://pub.dev/packages/djangoflow_firebase_analytics to for firebase_analytics support.
- [ ] Integrate https://pub.dev/packages/djangoflow_error_reporter and https://pub.dev/packages/djangoflow_sentry_reporter to for Sentry error handling.

## Organising

The way this project is organised inside the `packages/chat/lib` folder is as follows:

- `configurations` defines dynamic configurations per projects. These configurations are needed to setup the app which includes theme, router, global constants etc.
- `features` list of features according to their usage domain. Each of them are divided into 3 main layers
  - `data` bridge between business logic layer and external API with data manipulation. `presentation` should never directly communicate with this layer.
  - `blocs` is responsible for communicating with `data` and `presentation` layer. For specific events triggered from `presentation` layer, `blocs` layer will communicate with `data` layer to update information and perhapse update `state` of the `presentation` layer. The `state` should be immutable.
  - `presentation` is directly related to the UI of the app. It will send event to the `blocs` layer and listen to `state` dispatched from `blocs` layer to modify the UI.
- `utils` provides handy functionality that may be useful manipulate data and other useful functionalities.

## RUNNING THE APP

Run `flutter pub get` and after that `flutter pub run` to run the project.

## SETUP

There can be few customizations/setup regarding various aspect of the project. We'll discuss how to use those customization to bootstrap project quickly.

### OPENAPI REPOSITORY AND BLOCS

Openapi repository can be generated easily by using the script inside `{project_name}/tools/generate-openapi.sh` file.

- Make sure inside the `generate-openapi.sh` file the `hostname` variable has proper api endpoint.
- Then go to {project_name} folder which contains the tools folder. and run `sh tools/generate-openapi.sh -d` command to generate the openapi repository. the `-d` flag will use development api endpoint and using `-l` will use the local api endpoint defined in the `generate-openapi.sh` file.

To generate the Bloc from openapi generated repository you will need to annotate the class that you want to keep your generated blocs, repository into with
`@OpenapiRepository` annotation. An example can be found [here](./lib/data/api_repository/api_repository.dart) and then run `flutter pub run build_runner build --delete-conflicting-outputs`. Voila you'll have the required `ListBloc` and `DataBloc` automatically generated. 'ListBloc`and`DataBloc` comes from another set of packages. Which you can find and learn more about here : https://github.com/apexlabs-ai/list_bloc/

### APP ICONS

Chaning app icons for Android, iOS and Web can be a really hectice task to complete. In this project we have used [icons_launcher](https://pub.dev/packages/icons_launcher) package to quickly generate the app icons for all three platforms. Follow these steps to change the app icons for this project.

- Open [assets](./assets/) folder and replace the [logo.png](./assets/logo.png) and [logo_round.png](./assets/logo_round.png) with your own logo files.
- From project root directory run

```
flutter pub get
flutter pub run icons_launcher:create
```

This should generate/replace all the icons for Android, iOS and Web with your own icons.
More resources regarding customization using `icons_launcher` can be found here : https://pub.dev/packages/icons_launcher#attributes

### FIREBASE

Use [FlutterFire-CLI](https://firebase.flutter.dev/docs/cli/) to add firebase config to the project. And go to [web folder](./web/index.html) and configure firebase variables.

### APP SIGNING

#### ANDROID

To enable release build follow these steps properly https://docs.flutter.dev/deployment/android#signing-the-app

### FASTLANE

[Fastlane](https://fastlane.tools/) is one of the easiest way to build and release mobile applications. Saves a lot of effort and time for the developers.
We have added functionality to run fastlane for the project very easily. For iOS applications, it will upload to TestFlight. And for Android applications it will upload to playstore beta. Let's see how to configure fastlane to start building and uploading apps in one command.

Basic setup is already included. If you don't have `fastlane` installed on your system then you can follow [Fastlane docs](https://docs.fastlane.tools/) to get more info regarding that.

#### iOS

After making sure `fastlane` is already installed on your system let's proceed to adding iOS specific configuration.

- You will need to create and sign the iOS build using a distribution certificate instead of a development certificate when you’re ready to test and deploy using TestFlight or App Store.
  - Create and download a distribution certificate in your [Apple Developer Account console](https://developer.apple.com/account/ios/certificate/)
  - open [project]/ios/Runner.xcworkspace/ and select the distribution certificate in your target’s settings pane.
- After selecting a distribution certificate for signing the build, Go to `chat/ios/fastlane/` directory.
- Open and check the `Appfile` if the `app_identifier` matches your iOS `bundle_id`
- Create a new file named `.env`. Using this file we will provide environment variables for the `Appfile`.
  The `.env` file should look something like this

```
FASTLANE_APPLE_ID="" //here use your apple id for the project
FASTLANE_ITC_TEAM_ID=""// here it should be App Store Connect Team ID
FASTLANE_TEAM_ID="" // here it should be your Developer Portal Team ID
```

But feel free to custmize the iOS specific `Appfile` per your need. More information regarding `Appfile` can be found [here](https://docs.fastlane.tools/advanced/Appfile/#appfile)

The `Fastfile` contains one action, which is to build and upload the application to TestFlight. But one can modify and make more use out of it if needed. More information regarding this can be found [here](https://docs.fastlane.tools/getting-started/ios/beta-deployment/)

After configuring this, go to `/chat/ios` folder and run `fastlane beta` and `fastlane` make ask for authentication for appstore connect and from then it will take care of the rest.

#### Android

- Make sure you've signed your Android application by following these steps [Android app signing](https://docs.flutter.dev/deployment/android#signing-the-app)
- Download your google json key for playstore by following the described steps from this link: [Supply setup steps](https://docs.fastlane.tools/getting-started/android/setup/#setting-up-supply) Remember to keep the json file in a safe place.
- Go to `./android/fastlane` directory. You should see `Appfile` and `Fastfile`
- Check inside the `Appfile` if the `package_name` matches your Andriod application's package name.
- Create a new file named `.env` to supply the values for `Appfile` using environment variable. The `.env` file should look like this

```
FASTLANE_JSON_KEY_FILE="path_to_downloaded_json_key" // replace path_to_downloaded_json_key with the path where you've saved the downloaded json key
```

Inside the `Fastfile` there are four different actions.

- `test` : for running Android tests
- `internal`: for uploading a new build to the internal track of Playstore
- `beta` : for uploading a new build to the beta track of Playstore
- `deploy` : for uploading a new build to the production track of Playstore

After finishing Android configuration, you can run `fastlane beta` or `fastlane internal` etc to start an action your need from `./android` directory.

More official `Flutter` documents regarding integration of `fastlane` with `Flutter` can be found [here](https://docs.flutter.dev/deployment/cd#fastlane)

### WEB APP DEPLOYMENT

- Make sure `/.github/workflows` files are setup correctly. Some example of that can be found in `.github/workflows` directory. Mostly need to change the target names on both of the files and create one sandbox and another production deployment configs.
- After that, pushing any code to `main` branch should deploy to development env web app.
- Pushing tag in `main` branch should deploy to production evirnonment web app. Checkout to main branch and push a new tag with the updated version.
  example for deploying version 1.0.0 on production web app:

```
git checkout main
git tag 1.0.0
git push --tags
```

### Deep-linking

Deep linking is really useful for applications. Specific URLs can be redirected to the app which much much better in terms of UX and user engagement with the application.

This repository already uses the best practices for integrating Deep Linking in Flutter. They are divided into two parts, for iOS platform and for Android platform.

##### iOS

To enable Deep Links or Universal Links(This is what apple's terminalogy for it) one will need to do configure the project this way inside of `./ios`

- Go to `./ios/Runner` directory and open `Runner.entitlements` file and in `com.apple.developer.associated-domains` array key, add the website links that need be associated with. Example:

```xml
<key>com.apple.developer.associated-domains</key>
	<array>
		<string>applinks:your.domain.com</string>
		<string>applinks:your.domain.dev</string>
	</array>

```

- Now go to `./web/.well-known` directory. Open `apple-app-site-association` file and replace all the `{team_id}` with your apple development team id. For example if, `team_id = your_team_id` and `bundle_id = com.djangoflow.chat.dfchat` then `"apps": ["{team_id}.com.djangoflow.chat.dfchat"]` should become `"apps": ["your_team_id.com.djangoflow.chat.dfchat"]` After deploying the web app the process is done.

Now you've enabled Deep linking for iOS in your application. Test it by running for example this chat project `xcrun simctl openurl booted https://your.domain.com` should open the app in the running simulator if installed.

##### ANDROID

Deep linking prior to Android 12 is already configured. To modify the host urls that will redirect the user from url to app can be modified from the `AndroidManifest.xml` file. And update the `android:scheme` and android:host` values according to one's need.

To enable deep linking in Android application with Android 12+ follow this:

- Go to `./web/.well-known` directory
- Open `assetlinks.json` file
- Replace `{sha256_fingerprint}` with your app's signing key's sha256 fingerprint. You can learn more here: [Tutorial Link](https://medium.com/@idandamri/app-links-and-deep-links-with-android-12-765cf9bc9cca)

Now we have enabled deep linking for Android platform. Remember, we're using `web` folder to set the `.well-known` files but if you're not using web app and want to redirect user from any other website/web app you have you will need to upload these files `https://your_domain.name/.well-known/` directory.

### Troubleshoot

- If Android build is failing due to minSdkVersion constraints. Please open `./android/local.properties` file. And add the following line at the end of the document
  `flutter.minkSdkVersion=21`

- If you face `Integrity check failed: java.security.NoSuchAlgorithmException: Algorithm HmacPBESHA256 not available` Error during Android release builds follow this [Solution](https://stackoverflow.com/questions/67631927/error-building-aab-flutter-android-integrity-check-failed-java-security-n)
- Need add about local_notification android icon using `keep.xml` file following the [example](https://github.com/MaikuB/flutter_local_notifications/tree/master/flutter_local_notifications/example/) project
- For iOS local_notification configuration please check if `Google-service.info` file is present and linked properly. Can be checked from Xcode. If appears properly on Xcode then linked properly, if not then need to add/link. backgroundHandler should be a top level method, add it as early possible in the `main` method. Follow [this](https://firebase.google.com/docs/cloud-messaging/flutter/client) to ensure all the steps are done correctly