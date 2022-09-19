import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/shared/cubit/states.dart';
import '../../modules/archived tasks/Archived_tasks.dart';
import '../../modules/done tasks/Done_tasks.dart';
import '../../modules/new tasks/New_tasks.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);


  var currentIndex = 0;
  List<Widget> screens =
  [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  List<String> titles =
  [
    'My Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index)
  {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }


  late Database db;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDatabase()
  {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print('Database Created!');
        db
            .execute(
            'CREATE TABLE Tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('Table Created!');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (db) {
        getDataFromDatabase(db);

        print('Database Opend!');
      },
    ).then((value)
    {
      db = value;
      emit(CreateDatabaseState());

    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date
  }) async
  {
    await db.transaction((txn) async {
      txn.rawInsert(
          'INSERT INTO Tasks(title, date, time, status) VALUES("$title","$date","$time","new")'
      ).then((value) {
        print('$value Inserted Successfully');
        emit(InsertDatabaseState());

        getDataFromDatabase(db);

      }).catchError((error) {
        print('Error When Inserting new Task ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(db)
  {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(GetDatabaseLoadingState());

    db.rawQuery('SELECT * FROM Tasks').then((value)
    {
      value.forEach((element)
      {
        if(element['status'] == 'new')
          newTasks.add(element);
        else if(element['status'] == 'done')
          doneTasks.add(element);
        else if(element['status'] == 'archived')
          archivedTasks.add(element);
      });
      emit(GetDatabaseState());
      print(newTasks);
      print(doneTasks);
      print(archivedTasks);


    });
  }

  void updateDatabase({
    required String status,
    required int id,
})
  {
    db.rawUpdate(
        'UPDATE Tasks SET status = ? WHERE id = ?',
        [status, '$id']
    ).then((value)
    {
      getDataFromDatabase(db);
      emit(UpdateDatabaseState());

    });
  }

  void deleteData({
    required int id,
  })
  {
    db.rawDelete(
        'DELETE FROM Tasks WHERE id = ?',
        ['$id']
    ).then((value)
    {
      getDataFromDatabase(db);
      emit(DeleteDatabaseState());

    });
  }

  bool isBottomSheetShown = false;
  IconData fabicon = Icons.edit;

  void changeBottomSheet({
    required bool isShow,
    required IconData icon,
})
  {
    isBottomSheetShown = isShow;
    fabicon = icon;

    emit(ChangeBottomSheetState());
  }

}