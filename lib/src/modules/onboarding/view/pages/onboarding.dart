import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:chaseapp/src/shared/util/helpers/sizescaleconfig.dart';
import 'package:flutter/material.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
                itemCount: 3,
                onPageChanged: (index) {
                  setState(() {
                    pageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Page $index"),
                    ],
                  );
                }),
          ),
          Row(
            children: [
              Spacer(),
              for (var i = 0; i < 3; i++)
                Container(
                  color: i == pageIndex ? Colors.red : Colors.blue,
                  height: 10,
                  width: 10,
                  margin: EdgeInsets.all(20),
                ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    RouteName.CHECK_PERMISSIONS_VIEW_WRAPPER,
                  );
                },
                child: Text(
                  "Continue",
                ),
              )
            ],
          ),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
