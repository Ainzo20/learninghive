import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:learninghive/func.dart';
import 'package:learninghive/hive_objects/category.dart';
import 'package:learninghive/hive_objects/event.dart';
import 'package:learninghive/main.dart';
import 'package:status_alert/status_alert.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key});

  @override
  State<EventDetails> createState() => _EventDetailsState();

  static const routeName="event";
}

class _EventDetailsState extends State<EventDetails> with Func{
  final _formKey= GlobalKey<FormState>();
  Category? dropDownValue;
  final TextEditingController categoryController= TextEditingController();
  final TextEditingController eventNameController= TextEditingController();
  final TextEditingController eventDescriptionController= TextEditingController();
  Uint8List? imageBytes;
  bool completed =false ;
  bool viewed = false;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as EventArguments;

    if(args.view && !viewed){
      setState((){
        dropDownValue =args.event?.category[0];
        eventNameController.text = args.event!.eventName;
        eventDescriptionController.text= args.event!.eventDescription;
        imageBytes =args.event!.file;
        completed = args.event!.completed;
        viewed =true;
      });
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text ("Events",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16
        ),),
        centerTitle: false,
        //handeling events
        actions: [
          IconButton(onPressed: (args.view)?
          () {
            UpdateExistingEvent(args, context);
          } : null,
         icon: const Icon(Icons.save)),
          IconButton(
            onPressed:(args.view)?
           (){
            deleteMethod(context, args);
           }: null,
            icon: const Icon(Icons.delete)),
        ],



      ),
      body: Form(
        key:_formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          const Padding(
            padding:  EdgeInsets.only(top:10.0, left:10.0),
            child:  Text(
              "Select Category",
              style: TextStyle(
                color: Colors.blue),
                ),
          ),
              Padding(
                padding: const EdgeInsets.only(top:10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.5,
                  child: ValueListenableBuilder<Box<Category>>(valueListenable: categoryBox.listenable(),
                   builder:(context, box, widget){
                    return DropdownButton(
                      focusColor: const Color(0xffffffff),
                      dropdownColor:const Color(0xffffffff),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      isExpanded: true,
                      value:dropDownValue,
                      items: box.values.toList()
                    .map<DropdownMenuItem<Category>>((Category value){
                      return DropdownMenuItem(
                        value: value,child:Text(value.name));
                    }).toList(),
                     onChanged:( Category? newValue){
                      setState(() {
                        dropDownValue = newValue!;
                      });
                     });
                   }),
                ),
               ElevatedButton(
               style:  ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: Colors.lightBlue,
                foregroundColor: Colors.white
               ),
                onPressed: (){
                
                createNewCategory(context);
               }, child: 
                    const Icon(Icons.add)
                    ),
                 ],
                ),
              ),
                Padding(
          padding: const EdgeInsets.only(left:10.0,top:20.0, bottom: 20.0),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_month,
                color: Colors.blueAccent,
              ),
              Text(DateFormat("EEEE d MMMM").format(args.daySelected),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              )
            ],),
                ) ,
                Padding(
          padding: const EdgeInsets.only(bottom: 20.0, left: 10.0,right: 10.0),
          child: TextFormField(
            controller: eventNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Enter Event name",
              labelStyle: TextStyle(
                color: Colors.blueAccent
              )
            ),
          ),
                ),
                 Padding(
          padding: const EdgeInsets.only(bottom: 20.0, left: 10.0,right: 10.0),
          child: TextFormField(
            controller: eventDescriptionController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Enter Event Description",
              labelStyle: TextStyle(
                color: Colors.blueAccent
              )
            ),
          ),
                ),
               Padding(
                 padding: const EdgeInsets.only(bottom:15.0, left: 10.0,right: 10.0),
                 child: ListTile(
            tileColor: Colors.blue,
            textColor: Colors.white,
            iconColor: Colors.white,
            title:  const Text("Upload file"),
            trailing: (imageBytes !=null)
            ? const Icon(Icons.done)
            : const Icon(Icons.upload),
            onTap: ()async{
              FilePickerResult? result = 
              await FilePicker.platform.pickFiles();
                 
              if(result != null){
                File file = File(result.files.single.path!);
                imageBytes = await file.readAsBytes();
                //state to display the image
                setState(() {
                  
                });
              }
            },
           ),
               ),
                (imageBytes !=null) ?
                 Image.memory(
          imageBytes!,
           width:100,)
           : const SizedBox.shrink(),
           //if event is completed or not
            SwitchListTile(
              value: completed,
              title: const Text("Event Completed? ",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.blue
              ),),
               onChanged: (bool?value){
              setState(() {
                completed =value!;
              });
            }),
            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: (args.view) 
                  ? null 
                  : ()async{
                    //check if our form key current state is valid and drop down value is not null
          
                    if(_formKey.currentState!.validate() && dropDownValue!=null){
                      await addEvent(
                        Event(HiveList(categoryBox),
                         eventNameController.text,
                         args.daySelected,
                         eventDescriptionController.text,
                         imageBytes,
                         completed),
                         dropDownValue!);
                         if (context.mounted){
                          StatusAlert.show(
                            context,
                            duration: const Duration(
                              seconds:2,),
                              
                              subtitle: 'Event Added',
                              configuration: const IconConfiguration(
                                icon: Icons.done
                              ),
                            maxWidth: 200
                          );
                          Navigator.pop(context);
                         }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: const RoundedRectangleBorder(),
                    fixedSize: 
                      Size(MediaQuery.of(context).size.width*0.8, 50)),
                      child: const Text("Add")),
              ),
            ),
          
                ],
              ),
        ),
   ),
 );
}
  createNewCategory(BuildContext context){
    return showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: const Text(
            "New category",
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextFormField(
            controller: categoryController,
            decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Add Category",
            labelStyle: TextStyle(
              color: Colors.blueAccent,
              fontSize: 12.0,
            )
            ),
          ),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor:Colors.blueAccent,
              ),
              onPressed: (){
              Navigator.pop(context);
            }, child: const Text(
              "Cancel",
            )),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white
              ),
              onPressed: (){
                if(categoryController.text.isNotEmpty){
                  addCategory(Category(categoryController.text));
                  Navigator.pop(context);
                }
            }, child: const Text(
              "Save",
            ),)
          ],
        );
      }
      );

  }
    // ignore: non_constant_identifier_names
    UpdateExistingEvent(EventArguments args , BuildContext context){
      args.event?.category =HiveList(categoryBox);
      args.event?.date= args.daySelected;
      args.event?.eventName= eventNameController.text;
      args.event?.eventDescription=eventDescriptionController.text;
      args.event?.file= imageBytes;
      args.event?.completed = completed;

      updateEvent(args.event!, dropDownValue!);

      if (context.mounted){
        StatusAlert.show(context,
        duration: const Duration(seconds: 2),
        subtitle: "Event Updated!",
        configuration: const IconConfiguration(icon: Icons.done),
        maxWidth: 200 );
        Navigator.pop(context);
      }
 }

 deleteMethod(BuildContext context, EventArguments args ){
  return showDialog(context: context, builder: (context){
    return AlertDialog(
      content: const Text("Do you really want to delete this event?"),
      actions: [
        ElevatedButton(onPressed: (){
           deleteEvent(args.event!);

           if (context.mounted){
            StatusAlert.show(context,
            duration: const Duration(seconds: 2),
            subtitle: 'Event deleted!',
            configuration: const IconConfiguration(icon: Icons.done),
            maxWidth: 200,
            );
            Navigator.pop(context);
            Navigator.pop(context);
           }
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.blue,
        ), child: const Text("Yes")),
       

        OutlinedButton(onPressed: (){}, child: const Text("No"))
      ],
    );
  });
 }

}



class EventArguments{
  final DateTime daySelected;
  final Event? event;
  final bool view;

  EventArguments({required this.daySelected ,required this.view, this.event});
}

