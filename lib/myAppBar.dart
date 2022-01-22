import 'package:flutter/material.dart';

class MyAppBar extends AppBar {
  MyAppBar({Key? key, String title = "Timetracker", String? subTitle})
      : super(
          key: key,
          backgroundColor: Color(0xff283618),
          toolbarHeight: 75,
          title: Title(
            title: title,
            subTitle: subTitle,
          ),
        );
}

class Title extends StatelessWidget {
  const Title({Key? key, required this.title, this.subTitle}) : super(key: key);
  final String title;
  final String? subTitle;
  @override
  Widget build(BuildContext context) {
    if (subTitle == null) {
      return mainText();
    } else {
      return Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          mainText(),
          Container(margin: EdgeInsets.only(top: 5,),
            child: Text(
              subTitle!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          )
        ],
      );
    }
  }

  Text mainText() {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 25,
      ),
    );
  }
}
