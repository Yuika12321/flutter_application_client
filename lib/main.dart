import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';

var db = FirebaseFirestore.instance;
String categoryCollectionName = 'cafe_category';
String itemCollectionName = 'cafe_item';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({
    super.key,
  });

  @override
  State<Main> createState() => _MainState();
}

//진입점

class _MainState extends State<Main> {
  dynamic categoryList = const Text('category');
  dynamic itemList = const Text('item');

  // 장바구니 컨트롤러
  PanelController panelController = PanelController();

  // 카테고리 보기 기능
  Future<void> showCategoryList() async {
    // print(목록 출력 . . . .)
    var result = db.collection(categoryCollectionName).get();

    categoryList = FutureBuilder(
      future: result,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var datas = snapshot.data!.docs;
          if (datas.isEmpty) {
            return CustomRadioButton(
              elevation: 0,
              absoluteZeroSpacing: true,
              unSelectedColor: Theme.of(context).canvasColor,
              buttonLables: [for (var data in datas) data['categoryName']],
              buttonValues: [for (var data in datas) data.id],
              buttonTextStyle: const ButtonTextStyle(
                  selectedColor: Colors.white,
                  unSelectedColor: Colors.black,
                  textStyle: TextStyle(fontSize: 16)),
              radioButtonValue: (value) {
                print(value);
              },
              selectedColor: Theme.of(context).colorScheme.secondary,
            );
          }
        } else {
          return const Text('loading . . . ');
        }
      },
    );
  }

  // 아이템 보기 기능

  // 장바구니 보기 기능

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('집가고싶다.'),
        actions: [
          Badge(
            label: const Text('1'),
            child: IconButton(
                onPressed: () {
                  if (panelController.isPanelClosed) {
                    panelController.open();
                  } else {
                    panelController.close();
                  }
                },
                icon: const Icon(Icons.shopping_basket_sharp)),
          )
        ],
      ),
    );
  }
}
