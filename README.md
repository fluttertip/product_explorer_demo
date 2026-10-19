# Product Explorer

A small Flutter app that pulls products from the [DummyJSON](https://dummyjson.com/products?limit=10) API and shows them in a clean list with a detail page for each one. I built it as a practical test for an Android/Flutter role, so I kept the scope tight and spent the time on structure, error handling and the UI.


## Demo Video


https://github.com/user-attachments/assets/732d0ea0-37c9-4702-a698-d2d016ff31e4



## Download APK

[![Download APK](https://img.shields.io/badge/Download-Android%20APK-2ea44f?style=for-the-badge&logo=android&logoColor=white)](https://github.com/fluttertip/product_explorer_demo/raw/refs/heads/main/app.apk)

Download and install the Android APK to try Product Explorer on your device.


## What it does

- Fetches 10 products from `https://dummyjson.com/products?limit=10`
- Product list with thumbnail, brand, discounted price, original price and rating
- Product detail page with an image gallery, price and discount, stock status, tags, shipping/warranty/return info and customer reviews
- Search by title, brand or category
- Pull to refresh
- Proper loading, error (with retry) and empty states, including a "no matches" state for search
- Hero transition from the list image to the detail gallery

## Tech

- Flutter 3.22+ / Dart 3.3+
- [provider](https://pub.dev/packages/provider) for state management
- [http](https://pub.dev/packages/http) for the API call
- [cached_network_image](https://pub.dev/packages/cached_network_image) for images

## Project structure

```
lib/
├── core/         small helpers (price and date formatting)
├── models/       Product and Review, parsed defensively from JSON
├── services/     ProductApi, the only place that talks to the network
├── providers/    ProductProvider, holds the state and search logic
├── screens/      product list and product detail
├── widgets/      product card, image, rating, state message
└── main.dart
```

The flow is simple: `ProductApi` returns models, `ProductProvider` exposes a loading/loaded/error status plus the filtered list, and the screens just react to it. Network failures (no internet, timeout, bad status, bad JSON) are turned into readable messages in the service layer so the UI never deals with raw exceptions.

## Getting started

You need the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.

```bash
git clone <your-repo-url>
cd product_explorer

# generates the android/ios folders if they aren't in the repo
flutter create . --project-name product_explorer --platforms=android,ios

flutter pub get
flutter run
```

Release builds on Android need the internet permission. Add this line inside the `<manifest>` tag of `android/app/src/main/AndroidManifest.xml` (debug builds already have it):

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

To build an APK:

```bash
flutter build apk --release
```

## Tests

```bash
flutter test
```

## Notes

- Prices shown are the discounted price, calculated from `price` and `discountPercentage`, with the original price struck through.
- The API fields are all treated as optional in the model, so a missing field falls back to a sensible default instead of crashing.
- Search runs locally on the 10 fetched products.

The End



