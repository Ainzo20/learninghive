import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:learninghive/func.dart';
import 'package:learninghive/screens/event.dart';
import 'package:learninghive/widgets/category.dart';
import '../main.dart';
import '../hive_objects/event.dart';

class EventList extends StatelessWidget with Func {
  final DateTime date;
  final bool all;
  final bool filter;
  final String searchTerm;
  const EventList({super.key, required this.date, required this.all,required this.filter,required this.searchTerm});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Event>>(
      valueListenable: eventBox.listenable(), 
      builder:(context, box, widget){
        List<Event> events = (all)
        ? box.values.toList() 
        :(filter)
        ?searchEvent(searchTerm)
        : getEventByDate(date);


        if (events.isEmpty){
          return SizedBox(
            width: MediaQuery.of(context).size.width*0.7,
            child: EmptyWidget(
              image: null,
              packageImage: PackageImage.Image_1,
              title: 'Event Manager',
              subTitle: 'No events to display',
              titleTextStyle: const TextStyle(
                fontSize: 17,
                color: Color(0xff9da9c7),
                fontWeight: FontWeight.w500 ),
                subtitleTextStyle: const TextStyle(
                  color: Color(0xffabb8d6),
                  fontSize: 14
                ),
            ),
          );
        } else{
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
                      Navigator.pushNamed(context,
                       CategoryDetail.routeName,
                       arguments: CategoryArguments(category: events[index].category[0].name));
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

      }
    );
   }
}