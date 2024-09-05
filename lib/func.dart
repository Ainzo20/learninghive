import 'package:learninghive/hive_objects/category.dart';
import 'package:learninghive/hive_objects/event.dart';
import 'package:learninghive/main.dart';

mixin Func{
  //Functiion to create a new event
  addEvent(Event event, Category cat) async{
    //Add a category in the event
    event.category.add(cat);
    //Add a specific event object which holds a category into our event box
     event.category.add(cat);
     await eventBox.add(event);
     //now we save the event to be able to process the data
     event.save();
  }

  //Function to create a new category
  addCategory(Category category) async{
    //this is a simple class so it doesn't use HiveList that's why
    //We just add a category object and it creates it
    await categoryBox.add(category);
  }

  //Function to read and Event by dates which will be returning us a list of events
  List<Event> getEventByDate(DateTime dateTime){
  //lets implement the filter to get the events on a specific date 
  //so we take all the values in the event Box and apply the where function and make a query and convert the data to a list
  return eventBox.values.where((event) => event.date == dateTime).toList();
  }

  //Function to Update an Event
  //we need two tbjects to update an event 1 the event 2 its category 
  updateEvent(Event event, Category cat) async{
  //since HiveLists can store more than one events we need to clear the events which are aleady there to avoid duplication of events
  //we used.category because of the constraints you know event can't exist without a category
  event.category.clear();
  //then we add the event which was initially there 
  event.category.add(cat);
  //call our event box so we can update it we pass the event key and the event to the put method
  await eventBox.put(event.key, event);
  event.save();
  }

  //function to delete an Event
  deleteEvent(Event event) async{
    //we just call our event box and use the delete method and pass the event Key
    await eventBox.delete(event.key);

  }

  //Function to search an Event
  //we will be taking in a search word and sending out a list of events corresponding to the search word
  List<Event> searchEvent(String searchWord){ 
  //Now we write a query to compare the search word with the event name, description, or category name
  //we open the event box and call all its values use the where method to compare search word with its values
  return eventBox.values
  .where((event)=> event.eventName.contains(searchWord)|| 
      event.eventDescription.contains(searchWord)|| 
      event.category[0].name.contains(searchWord))
  .toList();

  }

  //function to getevent based on categories 
  List<Event> getByCategory(String category){
    
    return eventBox.values
    .where((event)=> event.category[0].name.contains(category))
    .toList();
  }
}