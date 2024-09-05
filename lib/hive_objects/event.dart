import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:learninghive/hive_objects/category.dart';

part 'event.g.dart';
@HiveType(typeId: 2, adapterName: "EventAdapter")
class Event extends HiveObject{
  @HiveField(0)
 HiveList<Category> category;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String eventName;

  @HiveField(3)
  String eventDescription;

  @HiveField(4)
  Uint8List? file;

  @HiveField(5)
  bool completed;

  Event(this.category,this.eventName,this.date,this.eventDescription,this.file,this.completed);
}