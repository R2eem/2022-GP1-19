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

### Targeted environment:

    The application soon will be only available on Google play store and would run on Android devices.

### Packages and dependencies:
- *First:* 

   - Name: parse_server_sdk_flutter

   - Version: 3.1.0

   - Usage: Install flutter plugin to get access to parse server backend 

   - Resource: https://pub.dev/packages/parse_server_sdk_flutter/score

   - Imports: 

                   - import 'package:flutter/material.dart';
        
                   - import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
    
- *Second:* 

   - Name: form_field_validator

   - Version: 1.1.0

   - Usage: Provides common form fields validations

   - Resource: https://pub.dev/packages/form_field_validator

   - Imports: 

                   - import 'package:form_field_validator/form_field_validator.dart';

- *Third:* 

   - Name: google_nav_bar

   - Version: 5.0.6

   - Usage: Bottom navigation bar

   - Resource: https://pub.dev/packages/google_nav_bar

   - Imports: 

                   - import 'package:google_nav_bar/google_nav_bar.dart';

- *Fourth:* 

   - Name: hexcolor

   - Version: 2.0.4

   - Usage: Include hex colors in the application

   - Resource: https://pub.dev/packages/hexcolor

   - Imports:

                  - import 'package:hexcolor/hexcolor.dart';

- *Fifth:* 

   - Name: flutter_launcher_icons

   - Version: 0.10.0

   - Usage: Update the application launcher ison

   - Resource: https://pub.dev/packages/flutter_launcher_icons

   - Imports: No imports

### Configuration:

- Sound null safety

  Sound null safety prevent some libraries from running
  
  - Run command:
  
               - flutter run --no-sound-null-safety
  
  

