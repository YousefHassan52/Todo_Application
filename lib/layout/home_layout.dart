import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:todo_app/modules/done_tasks/done_tasks.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';



class HomeScreen extends StatelessWidget {




  var scaffold=GlobalKey<ScaffoldState>();
  var form=GlobalKey<FormState>();

  HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>TodoCubit()..createDatabase(), // 2keno variable mn TodoCubit
      child: BlocConsumer<TodoCubit,TodoStates>(
        builder: (context,states)=>Scaffold(
          key: scaffold,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if(BlocProvider.of<TodoCubit>(context).sheetShown==true && form.currentState!.validate()==true)
              {
                BlocProvider.of<TodoCubit>(context).insertToDatabase(title: BlocProvider.of<TodoCubit>(context).titleController.text, time: BlocProvider.of<TodoCubit>(context).timeController.text, date: BlocProvider.of<TodoCubit>(context).dateController.text).then((value) {
                  BlocProvider.of<TodoCubit>(context).changeBottomSheet(isShown: false, fab: Icons.edit_note_rounded);
                });
                // .then((value) {
                 // Navigator.pop(context);

                //   sheetShown=false; مالوش لازمة خلاص ناقصنا بس الاضافة
                //   // setState((){
                //   //   fabIcon=Icons.edit_note_rounded;
                //   // });
                // });

              }
              else
              {
                BlocProvider.of<TodoCubit>(context).changeBottomSheet(isShown: true, fab: Icons.add);

                scaffold.currentState!.showBottomSheet((context) =>Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: form,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        defaultTextFormFieldForSheet(
                          label: "Title",
                          prefixIcon: Icons.title,
                          controller: BlocProvider.of<TodoCubit>(context).titleController,
                          validate: (value){
                            if(value==null || value.isEmpty) {
                              return "title required";
                            }
                            return null;
                          },
                          onTap: (){
                          },
                        ),
                        const SizedBox(height: 10,),
                        defaultTextFormFieldForSheet(label: "Time",
                          prefixIcon: Icons.watch_later_outlined,
                          controller: BlocProvider.of<TodoCubit>(context).timeController,
                          validate: (value){
                            if(value==null || value.isEmpty) {
                              return "time required";
                            }
                            return null;
                          },
                          onTap: (){
                            showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                              BlocProvider.of<TodoCubit>(context).timeController.text=value!.format(context).toString();
                              // print(timeController.text);
                            });
                          },),
                        const SizedBox(height: 10,),
                        defaultTextFormFieldForSheet(label: "Date",
                          prefixIcon: Icons.calendar_month_outlined,
                          controller: BlocProvider.of<TodoCubit>(context).dateController,
                          validate: (value){
                            if(value==null || value.isEmpty) {
                              return "date required";
                            }
                            return null;},
                          onTap: (){
                            showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(3000)).then((value) {
                              BlocProvider.of<TodoCubit>(context).dateController.text=DateFormat().add_yMMMd().format(value!);
                            });

                          },),


                      ],
                    ),
                  ),
                )
                ).closed.then((value) {
                  BlocProvider.of<TodoCubit>(context).changeBottomSheet(isShown: false, fab: Icons.edit);

                });

              }


            },
            child: Icon(BlocProvider.of<TodoCubit>(context).fabIcon),

          ),

          appBar: AppBar(
            elevation: 0.0,
            title:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Todo App",

                ),
                Text(
                  "${BlocProvider.of<TodoCubit>(context).screenTitle[BlocProvider.of<TodoCubit>(context).currentIndex]}",
                  style: TextStyle(fontSize: 14,
                      color: Colors.grey[300]),
                )
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: BlocProvider.of<TodoCubit>(context).currentIndex,
            onTap: (index){

              BlocProvider.of<TodoCubit>(context).changeScreen(index);

            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.menu_rounded),
                  label: "New Tasks"),
              BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline_rounded),
                  label: "Done Tasks"),
              BottomNavigationBarItem(icon: Icon(Icons.archive_outlined),
                  label: "Archived Tasks"),
            ],
          ),
          body: BlocProvider.of<TodoCubit>(context).screens[BlocProvider.of<TodoCubit>(context).currentIndex],
        ),
        listener: (context,state){
          if(state is InsertIntoDatabaseTodoState) {
            Navigator.pop(context);
          }

        },

      ),
    );
  }


}

