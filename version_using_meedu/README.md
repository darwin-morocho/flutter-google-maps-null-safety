# Uber clone with flutter and advanced markers

| Reverse geocode | Routes   |
|--------|----------------|
| ![Simulator Screen Shot - iPhone 11 - 2021-07-28 at 17 36 53](https://user-images.githubusercontent.com/15864336/127405069-a8bceb97-d96a-46c1-84de-687029e20f76.png)  | ![Simulator Screen Shot - iPhone 11 - 2021-07-28 at 17 37 13](https://user-images.githubusercontent.com/15864336/127405076-ad64e797-4d46-464c-bb34-1e099e61b4d0.png) |






This app uses [google_maps_flutter](https://pub.dev/packages/google_maps_flutter) for maps and [here API](https://developer.here.com) for reverse geocoding and routes.

## Deploy

- **Google API Key (with google maps enabled for iOS and Android):**
 First you need to define your google API key in the `AppDelegate.swift` and `AndroidManifest.xml`.

- **Set the here API KEY**
In the `const.dart `file `inside lib/app/helpers` you need to set an API(Rest API) key to be able to make requests to the here maps API

## About the project
This project uses [flutter_meedu](https://pub.dev/packages/flutter_meedu) as state management and dependency injection and creates a custom marker using a `CustomPainter`

### IMPORTANT:
❤️  Don't forget leave your like on **pub.dev** for [flutter_meedu](https://pub.dev/packages/flutter_meedu) and  **Github** if this project was useful for you 💪.

For more info check my Spanish course [https://meedu.app/curso/google-maps-con-flutter](https://meedu.app/curso/google-maps-con-flutter)

> Also you can find a version using **Provider** as state managment in https://github.com/darwin-morocho/flutter-google-maps-null-safety/tree/master/section_05
