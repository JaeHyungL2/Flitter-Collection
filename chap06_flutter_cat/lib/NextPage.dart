import 'package:flutter/cupertino.dart';
import 'package:chap06_flutter_cat/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NextPage extends StatefulWidget {
  const NextPage({super.key});

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  @override //홈페이지에 캣서비스를 컨슈머로 등록.
  Widget build(BuildContext context) {
    return Consumer<CatService>(builder: (context, catService, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            '좋아요만 따로 뺀 곳',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.indigo,
        ),
        body: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          padding: EdgeInsets.all(8),
          children: List.generate(catService.favoriteCatImages.length, (index) {
            String catImage = catService.favoriteCatImages[index];
            return GestureDetector(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      catImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Positioned(
                  //   child: Icon(
                  //     Icons.favorite,
                  //     color: catService.favoriteCatImages.contains(catImage)? Col,
                  //   ),
                  // ))
                ],
              ),
            );
          }),
        ),
      );
    });
  }
}
