import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
Widget defaultTextFormFieldForSheet({
  required String label,
  required IconData prefixIcon,
  required Function onTap,
  required FormFieldValidator<String> validate,
  required TextEditingController controller,
})=>TextFormField(
  validator: validate,
  onTap: (){onTap();},
  controller: controller,
  decoration: InputDecoration(
    label: Text("$label"),
    prefixIcon: Icon(prefixIcon),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20)
    ),

  ),
);
Widget defaultTaskItem(Map model,context)=>Dismissible(
  key: Key(model['id'].toString()),
  child:Padding(
    padding: const EdgeInsets.only(left: 10,
        right: 10,top: 10),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: CircleAvatar(
            radius: 35,
            child: Text(
              "${model["time"]}",
            ),
          ),

        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${model["title"]}",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5,),
              Text(
                "${model["date"]}",
                style: TextStyle(
                    color: Colors.grey[400]
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            BlocProvider.of<TodoCubit>(context).updateDatabase(id:model['id'] , status: "done");
          },
          icon: const Icon(Icons.check_box),),
        IconButton(
            onPressed: (){
              BlocProvider.of<TodoCubit>(context).updateDatabase(id:model['id'] , status: "archived");

            },
            icon: const Icon(Icons.archive)),

      ],
    ),
  ),
  onDismissed: (direction){
    BlocProvider.of<TodoCubit>(context).deleteDatabase(id: model['id']);

  },

);

Widget conditionalWidget({required List<Map> tasks,required String taskType}){
  return tasks.length>0?ListView.builder(
    itemBuilder: (context,index)=>defaultTaskItem(tasks[index],context),
    itemCount:tasks.length,
  ):Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/add1.png"),
        Text("No $taskType added yet !"),
      ],
    ),
  );
}


