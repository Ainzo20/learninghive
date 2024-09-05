import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:learninghive/func.dart';
import 'package:learninghive/hive_objects/event.dart';
import 'package:learninghive/main.dart';

import '../screens/event.dart';

class CategoryDetail extends StatefulWidget {
  const CategoryDetail({super.key});
  static const routeName = "category";
  @override
  State<CategoryDetail> createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> with Func {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CategoryArguments;
    return Scaffold(
      appBar: AppBar(
        actions: const [],
        backgroundColor:Colors.blue,
        foregroundColor: Colors.white,
        title: Text(args.category,
        style:const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ) ,),
      ),
      body:  ValueListenableBuilder<Box<Event>>(
      valueListenable: eventBox.listenable(), 
      builder:(context, box, widget){
        List<Event> events = getByCategory(args.category);

    return Padding(
      padding: const EdgeInsets.only(top:20.0,right: 10.0,left: 10.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: events.length,
        itemBuilder: (
          BuildContext context, int index
          ){
        return InkWell(
          onTap: (){
            Navigator.pushNamed(context, EventDetails.routeName,
            arguments: EventArguments(daySelected: events[index].date,
            view: true, 
            event:events[index]));
          },
          child: Card(
            color:Colors.white,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                   Column(
                    children: [
                      Text(DateFormat.E().format(events[index].date),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500
                      ),), 
                      Text(DateFormat.d().format(events[index].date),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.blueAccent,
                      ),) 
                    ],
                   ),
                 const Padding(
                    padding:  EdgeInsets.only(left:10.0),
                    child: VerticalDivider(
                      color: Colors.blue,
                      thickness: 2,
                      indent: 10,
                      endIndent: 10,
                     ),
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Text(
                    events[index].eventName,
                  ),
                  ActionChip.elevated(
                    label:  Text(events[index].category[0].name,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    ),
                    onPressed: (){
                      
                    },
                    backgroundColor: null,
                    color: const WidgetStatePropertyAll<Color>(Colors.lightBlue), )
                ],
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.blue,
            )
             ],
                ),
              ),
            ),
          ),
        );
      },
      ),
    );
    }


    )
    );
  }
}

class CategoryArguments{
  final String category;

  CategoryArguments({required this.category});
}