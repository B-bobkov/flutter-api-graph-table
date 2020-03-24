import 'package:flutter/material.dart';
import 'package:youtimizer/Modal/Shared.dart';
import 'package:youtimizer/Widgets/Loader.dart';
import 'package:youtimizer/Modal/Authentication.dart';
import 'package:youtimizer/Widgets/AppDrawer.dart';
import 'package:youtimizer/Widgets/ScreenTitle.dart';

final bgColor = const Color(0xff99cc33);

class ProfileScreen extends StatefulWidget {
  int uid;

  ProfileScreen({this.uid});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  Shared shared = Shared();
  Authentication authentication = Authentication();
  bool inProgress = true;
  String email = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchUser(widget.uid);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  fetchUser(uid) async {
    setState(() => inProgress = true);
    authentication.fetchUserData(uid).then((res) {
      print("User");
      print(res);

      setState(() {
        email = res['data']['user_email'];
      });
      print("Email ${email}");
    });
    setState(() => inProgress = false);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Container(
          height: 35.0,
          child: Image.asset("images/logo.png"),
        ),
        centerTitle: false,
      ),
      backgroundColor: Colors.black,
      endDrawer: AppDrawer(uid: widget.uid),
      body: inProgress
          ? Loader()
          : email != null
              ? ProfileScreenView(
                  email: email,
                )
              : Container(
                  child: Center(
                    child: Text("No data found",style: TextStyle(color: Colors.white),),
                  )
                ),
    );
  }
}

class ProfileScreenView extends StatelessWidget {
  String email;

  ProfileScreenView({this.email});

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return ListView(
      addAutomaticKeepAlives: true,
      shrinkWrap: true,
      children: <Widget>[
        ScreenTitle(title: "User Profile"),
         SizedBox(
          height: 15.0,
        ),
        Container(
          padding: EdgeInsets.only(top: 15.0),
          child: Text('Email: ${email}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 15.0),
          child: Text('Push Notification',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 15.0),
          child: Text('Weekly Email Notification',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 15.0),
          child: Text('Monthly Email Report',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          height: 100.0,
          color: Colors.black,
          child: Image.asset("images/logo.png"),
        ),
      ],
    );
  }

}
