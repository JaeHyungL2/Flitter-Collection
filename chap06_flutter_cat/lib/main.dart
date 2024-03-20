import 'package:chap06_flutter_cat/NextPage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//이렇게 프로바이더 등록.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CatService(prefs),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(), // <-- 이게문제네
    );
  }
}

//캣서비스 만들어주자 제일밖에서

class CatService extends ChangeNotifier {
  //상속받고
  SharedPreferences prefs;
  List<String> catImages = []; //이미지받을 리스트 선언.
  //좋아요 받을 리스트 배열로 하나 만들어주자.
  List<String> favoriteCatImages = [];

  CatService(this.prefs) {
    getRandomCatImages();
    favoriteCatImages = prefs.getStringList('image') ?? [];
  }
//고양이이 이미지 10개 가져오는 메서드

//고양이 사진가져오는 함수 만들자
  void getRandomCatImages() async {
    String path =
        "https://api.thecatapi.com/v1/images/search?limit=10&mime_types=gif";
    var result = await Dio().get(path);
    print(result.data); //고양이 이미지를 어플리케이션실행시 가져오게
    //요청으로 ->   <--이미지 넣으려고함...
    //현재는 함수만 만든상태.. 서비스에 로직해야지( 생성자)
    for (int i = 0; i < result.data.length; i++) {
      var map = result.data[i];
      print(map);
      print(map['url']);
      //cat이미지에 이미지url추가.    데이터길이만큼. 반복해서
      //맵이란 키벨류 쌍에서 url만 골라서 캣이미지 안에 넣어줌.
      catImages.add(map['url']);
    }
    notifyListeners();
  }

  //여기에다가 함수만들자,(좋아요 기능 구현해주는) ex)하트표시니 토글형식
  void toggleFavoriteImage(String catImage) {
    //string형식으로 이미지 가져올거고
    if (favoriteCatImages.contains(catImage)) {
      //cat이미지가 있으면
      favoriteCatImages.remove(catImage);
    } else {
      favoriteCatImages.add(catImage);
    }
    prefs.setStringList("image", favoriteCatImages);
    notifyListeners(); //이렇게 좋아요기능만들었으니, 온탭으로..
  }
}

//홈페이지 위젯만들어주자.↓
//stateless위젯만들어줌.  st누르면 자동
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override //홈페이지에 캣서비스를 컨슈머로 등록.
  Widget build(BuildContext context) {
    return Consumer<CatService>(
      builder: (context, catService, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '랜덤고양이',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.indigo,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NextPage()),
                  );
                  //아이콘 버튼 눌렀을때 동작.
                },
                icon: Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
              ),
            ],
          ), //스캐폴드 안에 앱바 하나만들어보자.
          //그리그 내 아이템 수를 기반으로 레이아웃을 구성할 수 있음. 레이아웃.
          body: GridView.count(
            //크로스 축으로 아이템이 2개씩 배치되도록설정
            crossAxisCount: 2,
            // 그리그의 주축(세로) 사이의 ㅇ이템 공간 설정
            mainAxisSpacing: 8,
            //그리그 크로스축(가로) 사이의 아이템 공간 설정
            crossAxisSpacing: 8,
            // 그리드 전체에 대한 패딩 설정
            padding: EdgeInsets.all(8),
            //그리드에 표시될 위젯의 리스트, 10개이ㅡ 위젯을 생성
            children: List.generate(catService.catImages.length, (index) {
              //cat이미지 가져와보자.
              String catImage = catService.catImages[index];
              //그리드뷰로와서
              return GestureDetector(
                //이러면 제각각으로나오니 되돌려주자.
                //스택이랑 이미지비슷한게 컬럼이니,
                child: Stack(
                  children: [
                    Positioned.fill(
                      //제스쳐디텍터 안에 2번감싸주자 알트+엔터
                      //좋아요기능위한 새로운 위젯 추가.
                      child: Image.network(
                        catImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                        child: Icon(
                      Icons.favorite,
                      color: catService.favoriteCatImages.contains(catImage)
                          ? Colors.red
                          : Colors.transparent,
                    ))
                  ],
                ),

                onTap: () {
                  catService.toggleFavoriteImage(catImage);
                }, //온탭넣기위해 제스쳐디텍티드로 감싸줌..);
              );
            }),
          ),
        );
      },
    );
  }
}
