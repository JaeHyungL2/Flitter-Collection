import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
//toDO리스트 조회기능먼저. if없을경우 보여주도록
// todo리스트 유무에따라..서 스테이

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

//상태클래스이고
class _HomePageState extends State<HomePage> {
  List<ToDo> toDoList = []; //todo리스트 하나 등록
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "TodoList",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: toDoList.isEmpty
          ? Center(
              child: Text('TodoList 작성해주세요'),
            )
          : ListView.builder(
              itemCount: toDoList.length,
              itemBuilder: (context, index) {
                ToDo toDo = toDoList[index];

                return ListTile(
                  title: Text(
                    toDo.job,
                    style: TextStyle(
                      fontSize: 20,
                      color: toDo.isDone ? Colors.grey : Colors.black,
                      decoration: toDo.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: IconButton(
                      //딜리트버튼클릭시, 알터창이 나오도록해보자!
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  '삭제할래?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      '취소',
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  //--삭제--
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        toDoList.removeAt(index);
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Text(
                                      '삭제',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      icon: Icon(CupertinoIcons.delete)),
                  onTap: () {
                    setState(() {
                      //상태바뀔때씀.!
                      toDo.isDone = !toDo.isDone; //이렇게 바뀐값에따라 값이 보여야하니
                    });
                  },
                );
              },
            ),
      //접근할수있게 액션버튼하나!
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //async는 값을 받아오기위해서.
          String? job = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreatePage()),
          );
          if (job != null) {
            setState(() {
              ToDo newToDo = ToDo(job, false); //생성자 하나만들어줌. 기본값은폴스
              toDoList.add(newToDo);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

//스테이트풀위젯 만들어보자 (홈페이지만들기위해)

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  //여기에 TExt필드 값 가져올때 사용할거 만들자
  TextEditingController textController = TextEditingController();
  //필드만들면 거기에있는 값 가져와주는친구
  //그리고
  //투두에 값이없을경우 경고뜨게하는법!(맨나중에)
  String? error; //메시지안나올수있으니 nullable로 선언

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'ToDoList 작성페이지',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(CupertinoIcons.chevron_back),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: textController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "할 일을 입력하세요.",
                errorText: error,
              ),
              //화면나올경우 입력창에 바로 오게하는기능 오토포커스
            ),
          ),
          SizedBox(
            //예시로 하나 더 넣어봄
            height: 20,
          ), // )
          // 1.row나 칼럼 등에서 위젯사이 빈공간 넣기위해서,
          // 2. child 위젯의 size를 강제하기위해 사용함'
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              //사이즈드박스 처음써보는데, 크게 2가지로 쓰임.
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  String toDo = textController.text;
                  if (toDo.isEmpty) {
                    setState(() {
                      error = "내용을 입력해랑!";
                    });
                  } else {
                    setState(() {
                      error = null; //내용이있으면.
                    });
                  }
                  Navigator.pop(context, toDo);
                  //이페이지에서 투두에 값을담았으니, 홈페이지는 받아야지?
                  //추가하기 버튼을 클릭하면 작동. alt+enter로
                },
                child: Text(
                  '추가하기',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

//ToDo클래스 만들어주자.
class ToDo {
  String job;
  bool isDone;

  ToDo(this.job, this.isDone);

//생성자는 알트+인설트
}
