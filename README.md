# Tiryaq

A new graduation project.

## Introduction
Tiryaq project is an Android app, will be launched in Saudi Arabia.
It's an app that gives you the opportunity to order your medications from the nearest pharmacies for pickup.

Our goal from this project is to:

- Help people save their time and effort in searching for their medications.
- Gather different pharmacies in one app.
- Help pharmacies reach their customers in an efficient manner.

## Technologies
Tiryaq is an app developed in Android studio using Flutter, Dart language.

## Launching instructions

If you want to experience Tiryaq app, you should download Android Studio and flutter plugin then download the APK to run the app, or you can download the code files of main branch and use Pixel 3a XL emulator to run the app.

- The app must run with no sound null safety

### Targeted environment:

 - The application soon will be only available on Google play store and would run on Android devices.

### Packages and dependencies:
- *First:* 

   - Name: parse_server_sdk_flutter

   - Version: 3.1.0

   - Usage: Install flutter plugin to get access to parse server backend 

   - Resource: https://pub.dev/packages/parse_server_sdk_flutter/score

   - Imports: 

                    import 'package:flutter/material.dart';
        
                    import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
    
- *Second:* 

   - Name: form_field_validator

   - Version: 1.1.0

   - Usage: Provides common form fields validations

   - Resource: https://pub.dev/packages/form_field_validator

   - Imports: 

                    import 'package:form_field_validator/form_field_validator.dart';

- *Third:* 

   - Name: google_nav_bar

   - Version: 5.0.6

   - Usage: Bottom navigation bar

   - Resource: https://pub.dev/packages/google_nav_bar

   - Imports: 

                    import 'package:google_nav_bar/google_nav_bar.dart';

- *Fourth:* 

   - Name: hexcolor

   - Version: 2.0.4

   - Usage: Include hex colors in the application

   - Resource: https://pub.dev/packages/hexcolor

   - Imports:

                   import 'package:hexcolor/hexcolor.dart';

- *Fifth:*

  - Name: flutter_launcher_icons

  - Version: 0.10.0

  - Usage: Update the application launcher icon

  - Resource: https://pub.dev/packages/flutter_launcher_icons

  - Imports: No imports
  
- *Sixth:*

  - Name: google_maps_flutter

  - Version: 2.2.1

  - Usage: Integrate google map with android application

  - Resource: https://pub.dev/packages/google_maps_flutter

  - Imports:
  
                   import 'package:google_maps_flutter/google_maps_flutter.dart';
  
- *Seventh:*

  - Name: geolocator

  - Version: 9.0.2

  - Usage: Acquire the current position of the device

  - Resource: https://pub.dev/packages/geolocator

  - Imports:
    
                    import 'package:geolocator/geolocator.dart';

- *Eighth:*

  - Name: full_screen_image

  - Version: 1.0.2

  - Usage: Full screen photo viewer

  - Resource: https://pub.dev/packages/full_screen_image

  - Imports: 
  
                    import 'package:full_screen_image/full_screen_image.dart';

- *Ninth:*

  - Name: native_notify

  - Version: 0.0.16

  - Usage: Push notification package

  - Resource: https://pub.dev/packages/native_notify

  - Imports:
  
                     import 'package:native_notify/native_notify.dart';
  
- *Tenth:*

  - Name: flutter_countdown_timer

  - Version: 4.1.0

  - Usage: Countdown timer widget

  - Resource: https://pub.dev/packages/flutter_countdown_timer

  - Imports:
  
                     import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
  
- *Eleventh:*

  - Name: flutter_image_slideshow

  - Version: any

  - Usage:  Image slideshow widget

  - Resource: https://pub.dev/packages/flutter_image_slideshow

  - Imports:
  
                     import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

- *Twelfth:*

  - Name: latlong

  - Version: 0.6.1

  - Usage: Calculate the distance between two coordinates

  - Resource: https://pub.dev/packages/latlong

  - Imports: 
  
                    import 'package:latlong/latlong.dart';

### Configuration:

- Sound null safety

  Sound null safety prevent some libraries from running
  
  - Run command:
  
                flutter run --no-sound-null-safety
  
  
### Fonts:

- FontFamily
  
  Font used in Tiryaq application is 'Lato'

  - Font: 
     
           fonts:
              - family: Lato
                fonts:
                  - asset: fonts/Lato-Black.ttf
                  - asset: fonts/Lato-Bold.ttf
                  - asset: fonts/Lato-Regular.ttf

