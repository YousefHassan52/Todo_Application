
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/states.dart';
import '../../../shared/cubit/cubit.dart';
import '../../shared/components/components.dart';
class NewTasks extends StatelessWidget {
  const NewTasks({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit,TodoStates>(
      builder: (context,state){
        var newTasks=BlocProvider.of<TodoCubit>(context).newTasks;

        return conditionalWidget(tasks: newTasks,taskType: "tasks");
        },
      listener: (context,state){},
    );

  }
}
