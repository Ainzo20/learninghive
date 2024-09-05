import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learninghive/hive_objects/category.dart';
import 'package:learninghive/hive_objects/event.dart';
import 'package:learninghive/screens/event.dart';
import 'package:learninghive/widgets/calender.dart';
import 'package:learninghive/widgets/category.dart';

late Box<Category> categoryBox;
late Box <Event>eventBox;
//late variables which will be later on initialized in the main function

const String categoryBoxName = "categories";
const String eventBoxName = "events";

const customKey ="Event_manager";
//names of the boxes
void main() async{

  await Hive.initFlutter();

  //create an instance for the secure storage
  const secureStorage = FlutterSecureStorage();

  final encryptionKeyString = await secureStorage.read(key:customKey);

  if(encryptionKeyString == null){
    final key = Hive.generateSecureKey();
    await secureStorage.write(key: customKey, value: base64UrlEncode(key));
  }

  final key = await secureStorage.read(key: customKey);
  final encryptionKeyUnit8List = base64Url.decode(key!);
  //We have to register our adapters
  Hive.registerAdapter<Category>(CategoryAdapter());
  Hive.registerAdapter<Event>(EventAdapter());

  //call our box and initialize our box by calling the Hive class passing the box name in the open boxfxn
  categoryBox= await Hive.openBox<Category>(categoryBoxName, encryptionCipher: HiveAesCipher(encryptionKeyUnit8List));
  eventBox= await Hive.openBox<Event>(eventBoxName, encryptionCipher: HiveAesCipher(encryptionKeyUnit8List));

  //compact boxes for deployment

  await categoryBox.compact();
  await eventBox.compact();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event manager app',
      theme: ThemeData(
        textTheme: Theme.of(context)
        .textTheme
        .apply(fontFamily: GoogleFonts.poppins().fontFamily),
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
     initialRoute: "/",
     routes: {
      "/":(context) => const Calendar(),
      EventDetails.routeName: (context)=> const EventDetails(),
      CategoryDetail.routeName:(context)=> const CategoryDetail(),
     },
     debugShowCheckedModeBanner: false,
    );

  }
}
