import 'package:hive/hive.dart';
//generate code by hive generator and build runner

part 'category.g.dart';

@HiveType(typeId: 1, adapterName: "CategoryAdapter")
class Category extends HiveObject{

//define our fields
//anotate and give and index to your field
@HiveField(0)
String name;

Category(this.name);
}