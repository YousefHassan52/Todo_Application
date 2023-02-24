// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/states.dart';

import '../../modules/archived_tasks/archived_tasks.dart';
import '../../modules/done_tasks/done_tasks.dart';
import '../../modules/new_tasks/new_tasks.dart';

class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() :super(InitialTodoState());
  static TodoCubit get(context) => BlocProvider.of(context);
  var timeController=TextEditingController();
  var titleController=TextEditingController();
  var dateController=TextEditingController();
  List <String> screenTitle=[
    "New Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];
  List<Widget> screens=[
    const NewTasks(),
    const DoneTasks(),
    const ArchivedTasks(),
  ];

  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];
  int currentIndex = 0;
  bool sheetShown = false;
  IconData fabIcon = Icons.edit;


  void changeScreen(int index) {
    currentIndex = index;
    emit(BottomNavBarTodoState());
  }


  late Database data;

  void createDatabase() {
    openDatabase(
      "todo_new_app",
      version: 1,
      onCreate: (database, version) {
        // print("table created");
        database.execute(
            "CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,time TEXT,date TEXT,status TEXT)")
            .then((value) {
          // print("table created");
        }).catchError((error) {
          // print("error while creating table tasks: ${error.toString()}");
        });
      },
      onOpen: (database) {
        // print("database opened");
        getData(database);
      },
    ).then((value) {
      // el value heya el database
      data = value;
      emit(CreateDatabaseTodoState()); // ha emit lma ye5las 34an kda badal ma 2a2ol data=await openDatabase 2olt data = vale fa heya heya

    });
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await data.transaction((txn) {
      return txn.rawInsert(
          'INSERT INTO tasks(title,time,date,status) VALUES ("$title","$time","$date","new")')
          .then((value) {
        // print("record of id $value is added");
        emit(InsertIntoDatabaseTodoState());
        getData(data);
      })
          .catchError((error) {
        // print("error while inserting data ${error.toString()}");
      });
    });
  }

  void getData(Database database) {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];

    database.rawQuery('SELECT * FROM tasks').then((value) {
      for (var element in value) {
        if(element['status']=='new') {
          newTasks.add(element);
        } else if(element['status']=='done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }

      }


      emit(GetFromDatabaseTodoState());
    });
  }

  void changeBottomSheet({
    required bool isShown,
    required IconData fab}) {
    sheetShown = isShown;
    fabIcon = fab;
    emit(ChangeBottomSheetTodoState());
  }
  void updateDatabase({required int id, required String status})async{
    await data.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      // print('updated: $id');
      getData(data);
      emit(UpdateDatabaseTodoState());



    });


  }
  void deleteDatabase({required int id})async{
    await data.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getData(data);
      emit(DeleteDatabaseTodoState());



    });


  }

}