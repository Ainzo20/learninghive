import 'package:flutter/material.dart';
import 'package:learninghive/screens/event.dart';
import 'package:learninghive/widgets/event_list.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime daySelected =DateTime.utc(DateTime.now().year,DateTime.now().month,
  DateTime.now().day);
  bool search = false;
  final TextEditingController searchController = TextEditingController();
  bool viewAll = false;
  bool filter = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: (search) ?
        TextField(
         controller: searchController, 
         cursorColor:  Colors.white,
         onChanged: (value){
          setState(() {
            viewAll=false;
            filter = true;
          });
         },
         style: const TextStyle(
          color: Colors.white,
         ),
         decoration:const InputDecoration(
          hintText: "Search Here",
          hintStyle: 
          TextStyle( fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.white)),
        )
        :const Text("Event Manager",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          color: Colors.white
          ),
        ),
        actions: [
          (search)
          ? IconButton(
            onPressed: (){
              setState(() {
              search = false; 
            });
          }, 
          icon: const Icon(
            Icons.cancel,
            color: Colors.red,
            )) 
            :  IconButton(onPressed: (){
            setState(() {
              search = true; 
              viewAll = true;
            });
          }, 
          icon: const Icon(
            Icons.search,color: Colors.white,)
           )],

      ),
      //our body is a singleChild Scrollview that holds our column 
      body:SingleChildScrollView(
        child: Column(
          //lets implement our table calender here
          children: [
            Visibility(
              visible: !search,
              child: Column(
                children: [
                  TableCalendar(firstDay: DateTime.utc(2024,1,1),
                             lastDay: DateTime.utc(2050),
                             focusedDay:daySelected ,
                             currentDay: daySelected,
                             //lets write a function to get the day selected 
                             onDaySelected: (selectedDay, focusedDay){
                  setState(() {
                    daySelected = selectedDay;
                  });
                             },
                             ),
                            Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                     child: OutlinedButton.icon(onPressed: (){
                      Navigator.pushNamed(context, EventDetails.routeName,
                      arguments:EventArguments(daySelected:DateTime.utc(daySelected.year,
                       daySelected.month,daySelected.day), view: false,));
                       
                     }, 
                     label: const Text("Add Event"),
                     icon: const Icon(Icons.add),
                     ),
                   ),
                            ),
                ],
              ),
            ),
          //Now let's display events for a specific day
     EventList(
            filter: filter,
            searchTerm:searchController.text ,
            all: viewAll,
            date: DateTime.utc(
            daySelected.year, 
            daySelected.month,
            daySelected.day)),
          ],
        ),
      ),
    );
  }
}