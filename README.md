# Tiryaq

A new graduation project.

## Introduction
Tiryaq project is an Android app and admin dashboard , will be launched in Saudi Arabia.
It's a system that gives you the opportunity to order your medications from the nearest pharmacies for pickup.

Our goal from this project is to:

- Help people save their time and effort in searching for their medications.
- Gather different pharmacies in one app.
- Help pharmacies reach their customers in an efficient manner.

## Technologies
Tiryaq app is developed in Android studio using Flutter and Dart language.
Tiryaq admin dashboard developed in visual studio using HTML and Javascript.

## Launching instructions
### App
If you want to experience Tiryaq app, you can download Android Studio and flutter plugin then download the code files of main branch and use Pixel 3a emulator, or
download the APK to run the app.

- The app must run with no sound null safety

### Dashboard 
If you want to experience Tiryaq admin dashboard, you can download the "Admin Dashboard folder" from main branch, or
open google chrome browser and visit the link https://tiryaq.b4a.app/ to run the dashboard.

### Log in credentials
App:

-Customer
 
 Email: noura-alfouzan@hotmail.com

 Password: Noura00@

-Pharmacy
Email:lemon@hotmail.com 
Password: LemonPharm2011@

-Admin Dashboard
account1:
Email: shahad@gmail.com
Password: Shahad1234*

account2:
Email: noura@gmail.com
Password: Noura00@

### Github link 
https://github.com/R2eem/2022-GP1-19.git

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

