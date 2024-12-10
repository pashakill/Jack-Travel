import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:travelappui/components/app_text.dart';
import 'package:travelappui/components/color_collections.dart';
import 'package:travelappui/routes/navigator_provider.dart';

@RoutePage()
class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  @override
  Widget build(BuildContext context) {
    AutoRouter.of(context);

    Size size = MediaQuery.of(context).size;
    ThemeData appTheme = Theme.of(context);
    return Scaffold(
      body: Column(children: [
        Container(
          height: size.height * 0.55,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36))),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36)),
            child: Image(
              image: AssetImage('assets/image/pic3.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: size.height * 0.45,
          padding: EdgeInsets.all(32),
          alignment: Alignment.bottomCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                  child: Text(
                "Winter Vaction Trips!",
                maxLines: 2,
                overflow: TextOverflow.clip,
                style: AppText.bold14pxBlack,
              )),
              SizedBox(height: 18),
              Text(
                "Enjoy your winter vacation with warmth and amazing sightseeing on the mountains. Enjoy the best experience with us!",
                maxLines: 4,
                overflow: TextOverflow.fade,
                style: AppText.normal12pxLightGrey,
              ),
              SizedBox(height: 18),
              ElevatedButton(
                  onPressed: () {
                    context.router.pushNamed(PagePathCollections.homePage);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorCollections.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                      textStyle: TextStyle(
                          fontSize: 18,
                          fontFamily: 'PlayFair',
                          fontWeight: FontWeight.bold)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("Let's Go! "),
                  ))
            ],
          ),
        )
      ]),
    );
  }
}
