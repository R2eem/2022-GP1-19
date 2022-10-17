import 'package:untitled/style/colors.dart';
import 'package:flutter/material.dart';

import 'style/styles.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        fontFamily: 'Gordita',
      ),
      home: const CategoryPage(),
    );
  }
}

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
              padding: const EdgeInsets.only(left: 15),
              height: size.height / 4,
              width: size.width,
              decoration: const BoxDecoration(
                color: AppColors.babypink,
                // image: DecorationImage(
                //     image: AssetImage('assets/logo.png'),
                //     alignment: Alignment.bottomCenter,
                //     fit: BoxFit.cover)
              ),
              child: SafeArea(
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/logo.png',
                              fit: BoxFit.contain,
                              width: 100,
                              height: 85,
                            ),
                            //Image.asset('assets/logo.png'),
                            const SizedBox(
                              width: 12,
                            ),
                            Text('Sakura', style: AppStyle.m12w)
                          ],
                        ),

                        const SizedBox(
                          height: 0,
                        ),
                        Text(
                          'What are you locking for?',
                          style: AppStyle.b32w,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        // Text(
                        //   'Choose your category',
                        //   style: AppStyle.r12w,
                        // )
                      ],
                    )),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            height: size.height - (size.height / 5),
            width: size.width,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(34)),
            child: Column(children: [

              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: const [
                        MedicationCategories(
                            background: AppColors.babypink,
                            title: 'Non-Prescription medication',
                            subtitle: '',
                            image: 'assets/medicationnono.png'),
                        MedicationCategoriesno(
                            background: AppColors.pink,
                            title: 'Prescription medication',
                            subtitle: '',
                            image: 'assets/medecationwith.png'),
                      ],
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      ]),
    );
  }
}

class MedicationCategories extends StatelessWidget {
  final Color background;
  final String title;
  final String subtitle;
  final String image;
  const MedicationCategories(
      {Key? key,
        required this.background,
        required this.title,
        required this.subtitle,
        required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        onTap: () {
          print("Go to NON-Prescription medication");
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          width: 300,
          height: 200,
          decoration: BoxDecoration(
              color: Colors.pink[50],
              borderRadius: BorderRadius.circular(34),
              border: Border.all(color: Colors.white, width: 8),
              boxShadow: [
                BoxShadow(
                    blurRadius: 50,
                    color: const Color(0xFF0B0C2A).withOpacity(.09),
                    offset: const Offset(10, 10))
              ]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(height: 20),
            Text(title, style: AppStyle.m12w),
            Text(subtitle, style: AppStyle.r10wt),
            const SizedBox(height: 1),
            Expanded(child: Image.asset(image)),
          ]),

        ),
      );

  }
}


class MedicationCategoriesno extends StatelessWidget {
  final Color background;
  final String title;
  final String subtitle;
  final String image;
  const MedicationCategoriesno(
      {Key? key,
        required this.background,
        required this.title,
        required this.subtitle,
        required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Go to Prescription medication");
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        width: 300,
        height: 200,
        decoration: BoxDecoration(
            color: const Color(0xFFE1BEE7),
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: Colors.white, width: 8),
            boxShadow: [
              BoxShadow(
                  blurRadius: 50,
                  color: const Color(0xFF0B0C2A).withOpacity(.09),
                  offset: const Offset(10, 10))
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(height: 20),
          Text(title, style: AppStyle.m12w),
          Text(subtitle, style: AppStyle.r10wt),
          const SizedBox(height: 1),
          Expanded(child: Image.asset(image)),
        ]),
      ), );
  }
}