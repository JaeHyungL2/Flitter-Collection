import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

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
//api호출위한 함수만들자.

//stl해서 위젯만들고
class HomePage extends StatefulWidget {
  const HomePage({super.key});

//퀴즈버튼누를때 동적으로, 새로운결과값으로 출력시켜줘야하니..
  //상태가 자꾸바뀌니.. statefull위젯으로 바꿔줘야함.. 비동기-동기로.\\
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String quiz = '퀴즈';

//방금 alt+insert로 initState 추가함.!
  //StatefulWidget에서 위젯이 처음 생성될 때 실행되는 함수임. - initState()는..
  @override
  void initState() {
    super.initState(); //거의 고정값.사용하려면..
    //부모클래스에서 쓰기위해
    getQuiz();
  }

  Future<String> getNumbertrivia() async {
    String path = 'http://numbersapi.com/random/trivia';
    Response result = await Dio().get(path);

    String trivia = result.data;
    print(trivia);
    return trivia;
  }

  void getQuiz() async {
    //메소드 하나 만들어주자.  어웨잇나오면 어싱크 한세트!
    String trivia = await getNumbertrivia();
    setState(() {
      //
      quiz = trivia;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.indigo,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            /*
            설명가자!
            크로스축이란..?
             - 주축의 반대되는 축을 크로스축이라고함.
             ex) Column같은경우 세로로쌓지만(주축은세로방향),
                 Cross축은 - 주축은 가로방향.  (위젯들의 주축방향은 정해져있음)
                 주축들의 반대를 그냥 Cross라고함..
             */

            //아래는 크로스축 방향으로 가능한 많은 공간을 차지함.
            crossAxisAlignment: CrossAxisAlignment.stretch,
            //여기있네 ↑ crossAxisAlignment. 퀴즈가
            children: [
              Expanded(
                /* 그다음 Exapnded위젯은 레이아웃위젯으로,
                자식위젯이 사용가능한 추가공간을 모두 차지하도록 확장시키는 역할을 함.
                주로, Row, Column같은 레이아웃 위젯 사용시, 내부에 자식위젯들 사이의 공간을
                동적으로 분배할 목적으로 사용됨.  -프레임워크처럼 틀과 정답이 정해져서.. 뀌미는, 바라보는관점자의 몫이군
                 */
                child: Center(
                  child: Text(
                    quiz,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.yellow,
                    ),
                  ),
                ),
              ),
              //퀴즈생성ㅍ버튼
              SizedBox(
                height: 42,
                child: ElevatedButton(
                    onPressed: () {
                      //퀴즈생성버튼 누르면 동작., trivia 요청이 잘가면, 출력이될 것
                      //메소드호출시 트리비아에 값을 담아주자. q비동기니-> 동기형식으로 어싱크

                      getQuiz(); //
                    },
                    child: Text(
                      'New Quiz',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 24,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
//홈페이지위젯구성해보자, 기본구성은 스캐폴드로. 그안에 바디만넣고
//

//매일하던거 하면되고. 커밋하자.
//뭔진 모르겠지만 ㅋ 요청해보자..->
//https://numbersapi.com/random/trivia url로 요청보내면,
//저걸 반복해서 출력하는 앱 만들거임..

//dio ㅏㅅ용방법은 간단..
//dio().get("요청");
//시간걸리면 비동기로...  동기로작동하려면 async& await붙여주면된다.

//홈페이지만들자.
