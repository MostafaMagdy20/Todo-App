import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'layout/Todo Home/Todo_home.dart';
import 'shared/bloc_observer.dart';

void main()
{
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
        title: 'TODO',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
              centerTitle: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              iconTheme: IconThemeData(
                  color: HexColor('4F6457')   //arrow icon for go back
              )
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: HexColor('D9B44A'),
              elevation: 50.0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: HexColor('4F6457'),
              unselectedItemColor: HexColor('4F6457'),
              showUnselectedLabels: false
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: TodoHome()

    );
  }

}


