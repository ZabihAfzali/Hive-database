import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_database_practice/boxes/boxes.dart';
import 'package:hive_database_practice/models/notes_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final titleController=TextEditingController();
  final descriptionController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hive Database"),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context,box,_){
          var data=box.values.toList().cast<NotesModel>();
          return ListView.builder(
             //reverse: true,
              itemCount: box.length,itemBuilder: (context,index){
            return Container(
              height: 90,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(data[index].title.toString(),style: TextStyle(fontWeight: FontWeight.w700,fontSize: 15),),
                          Spacer(),
                          InkWell(
                            onTap: (){
                              delete(data[index]);
                            },
                            child: Icon(Icons.delete, color: Colors.red,),
                          ),
                          SizedBox(width: 15,),
                          InkWell(
                            onTap: (){
                              _editDialogue(data[index], data[index].title.toString(), data[index].description.toString());
                            },
                            child: Icon(Icons.edit),
                          )


                        ],
                      ),
                      Text(data[index].description.toString(),style: TextStyle(fontSize: 10),),
                    ],
                  ),
                ),
              ),
            );
          });
        },

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showMyDialogue();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showMyDialogue() async{
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Add notes'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Enter  tilte',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'Enter  description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            final data=NotesModel(title: titleController.text, description: descriptionController.text);
            final box=Boxes.getData();
            box.add(data);

            //data.save();

            print(box);

            titleController.clear();
            descriptionController.clear();


            Navigator.pop(context);
          }, child: Text("Add")),

          TextButton(onPressed: (){
            titleController.clear();
            descriptionController.clear();
            Navigator.pop(context);
          }, child: Text("Cancel")),
        ],
      );
    });
  }

  Future<void> _editDialogue(NotesModel notesModel, String title, String description) async{

    titleController.text=title;
    descriptionController.text=description;


    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Edit notes'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Enter  tilte',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'Enter  description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: (){

            notesModel.title=titleController.text.toString();
            notesModel.description=descriptionController.text.toString();
            notesModel.save();



            titleController.clear();
            descriptionController.clear();


            Navigator.pop(context);
          }, child: Text("Edit")),

          TextButton(onPressed: (){
            titleController.clear();
            descriptionController.clear();

            Navigator.pop(context);
          }, child: Text("Cancel")),
        ],
      );
    });
  }


  void delete(NotesModel notesModel) async{
    notesModel.delete();
  }
}


/*
  FutureBuilder(
                future: Hive.openBox("Zabi"),
                builder: (context, snapshot) {
              return Column(
                children: [
                  Text(snapshot.data!.get('name').toString()),
                  Text(snapshot.data!.get('value').toString()),
                  Text(snapshot.data!.get('details').toString()),
                ],
              );
            })



            floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var box = await Hive.openBox("Zabi");
          box.put("name", "Zabiullah");
          box.put('value', 23);
          box.put('details',
              {'pro': 'developer', 'stage': 'first', 'class': 'nursery'});
          print(box.get("name"));
          print(box.get("value"));
          print(box.get("details"));
        },
        child: Icon(Icons.add),
      ),

 */