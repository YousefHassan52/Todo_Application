
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/states.dart';
import '../../../shared/cubit/cubit.dart';
import '../../shared/components/components.dart';
class DoneTasks extends StatelessWidget {
  const DoneTasks({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit,TodoStates>(
      builder: (context,state){
        var doneTasks=BlocProvider.of<TodoCubit>(context).doneTasks;

        return conditionalWidget(tasks: doneTasks,taskType: "done tasks");
      },
      listener: (context,state){},
    );

  }
}
