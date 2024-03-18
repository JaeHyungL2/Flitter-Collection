import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

// ToDOList 담당
class ToDoService extends ChangeNotifier {
  List<ToDo> toDoList = [
    // 더미데이터
    ToDo('공부하기', false),
  ];

  // todo 추가
  void createToDo(String job) {
    toDoList.add(ToDo(job, false));
    // 갱신 : Consumer로 등록된 곳의 builder 만 새로 갱신해서 화면을 그려줌.
    notifyListeners();
  }

  // todo 수정  //글머 여기서 기존에있던 todo바꿔줘서, .
  void updateToDo(ToDo toDo, int index) {
    toDoList[index] = toDo;
    notifyListeners(); //갱신해줌.
  }

  //삭제.
  void deleteToDo(int index) {
    toDoList.removeAt(index);
    notifyListeners();
  }
}

// 여기 서비스에서 로직들을 만들어보자.

//todo서비스가 최상단에있고, 그 아래에 변경을 알려주고,  컨슈머로 등록해서, 등록된 위젯들에게 상태바뀌었으니, 알림을줌..
//그럼 위젯들이 빌드되면서 변경사항들 아래로 쭈욱 관리가능...상단만하면..

//한곳에서 관리하기에 데이터관리에 용이해짐!..장점.
