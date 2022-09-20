import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/shared/components/components.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';



class TodoHome extends StatelessWidget
{

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();

  TodoHome({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit , AppStates>(
        listener: (context, state)
        {
          if(state is InsertDatabaseState)
          {
            Navigator.pop(context);
          }
        },
        builder: (context, state)
        {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            backgroundColor: Colors.white,
            key: scaffoldKey,
            appBar: AppBar(
              shadowColor: HexColor('4F6457'),
              backgroundColor: HexColor('D9B44A'),
              elevation: 3.0,
              title: Text(
                cubit.titles[cubit.currentIndex],
                style: TextStyle(
                    color: HexColor('4F6457')
                ),
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! GetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator(
                color: HexColor('D9B44A'),
              )),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: HexColor('D9B44A'),
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate())
                  {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                  }
                } else
                {
                  scaffoldKey.currentState?.showBottomSheet((context) => Container(
                    color: HexColor('D9B44A'),
                    padding: const EdgeInsetsDirectional.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultTFF(
                              controller: titleController,
                              tffColor: HexColor('4F6457'),
                              type: TextInputType.text,
                              label: 'Task Title',
                              prefix: Icons.title,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ('Title Must Be Found');
                                }
                              }),
                          const SizedBox(
                            height: 15.0,
                          ),
                          defaultTFF(
                              controller: timeController,
                              tffColor: HexColor('4F6457'),
                              onTap: () {
                                showTimePicker(
                                    builder: (context , child)
                                    {
                                      return Theme(
                                          data: ThemeData.light().copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: HexColor('D9B44A'), // header background color
                                              onPrimary: HexColor('4F6457'), // header text color
                                              onSurface: HexColor('4F6457'), // body text co
                                            ),
                                          ),
                                          child: child!
                                      );
                                    },
                                    context: context,
                                    initialTime: TimeOfDay.now()).then((value)
                                {
                                  timeController.text =
                                      value!.format(context);
                                });
                              },
                              type: TextInputType.datetime,
                              label: 'Task Time',
                              prefix: Icons.watch_later_outlined,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ('Time Must Be Found');
                                }
                              }),
                          const SizedBox(
                            height: 15.0,
                          ),
                          defaultTFF(
                              controller: dateController,
                              tffColor: HexColor('4F6457'),
                              onTap: () {
                                showDatePicker(
                                    builder: (context , child)
                                    {
                                      return Theme(
                                          data: ThemeData.light().copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: HexColor('D9B44A'), // header background color
                                              onPrimary: HexColor('4F6457'), // header text color
                                              onSurface: HexColor('4F6457'), // body text co
                                            ),
                                          ),
                                          child: child!
                                      );
                                    },
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate:
                                    DateTime.parse('2030-03-03')).then((value)
                                {
                                  dateController.text =
                                      DateFormat.yMMMd().format(value!);
                                }).catchError((error) {});
                              },
                              type: TextInputType.datetime,
                              label: 'Task Date',
                              prefix: Icons.calendar_month,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ('Date Must Be Found');
                                }
                              })
                        ],
                      ),
                    ),
                  ),
                    elevation: 20.0,
                  ).closed.then((value) {
                    cubit.changeBottomSheet(
                        isShow: false,
                        icon: Icons.edit
                    );
                  });
                  cubit.changeBottomSheet(
                      isShow: true,
                      icon: Icons.add
                  );
                }
              },
              child: Icon(
                cubit.fabicon,
                color: HexColor('4F6457'),
              ),
            ),
            bottomNavigationBar: CurvedNavigationBar(
                color: HexColor('D9B44A'),
                height: 58.0,
                animationDuration: const Duration(milliseconds: 350),
                index: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                backgroundColor: Colors.white,
                items: [
                  Icon(
                    Icons.menu_rounded,
                    color: HexColor('4F6457'),
                  ),
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: HexColor('4F6457'),
                  ),
                  Icon(
                    Icons.archive_rounded,
                    color: HexColor('4F6457'),
                  )
                ]),
          );
        },
      ),
    );
  }

}



// bottomNavigationBar: Container(
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.only(
//           topRight: Radius.circular(30), topLeft: Radius.circular(30)),
//       boxShadow: [
//         BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
//       ],
//     ),
//     child: ClipRRect(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(30.0),
//         topRight: Radius.circular(30.0),
//       ),
//       child: BottomNavigationBar(
//         onTap: (int index)
//         {
//           cubit.changeIndex(index);
//         },
//         currentIndex: cubit.currentIndex,
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.menu_rounded,
//             ),
//             label: 'Tasks',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.check_circle_outline_rounded,
//             ),
//             label: 'Done',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.archive_rounded,
//             ),
//             label: 'Archived',
//           ),
//         ],
//       ),
//     )
// )
