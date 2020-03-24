import 'package:flutter/material.dart';
import 'package:youtimizer/Pages/Login.dart';
import 'package:youtimizer/Modal/Shared.dart';
import 'package:youtimizer/Widgets/Loader.dart';
import 'package:youtimizer/Modal/Authentication.dart';
import 'package:youtimizer/Widgets/AppDrawer.dart';
import 'package:youtimizer/Widgets/ScreenTitle.dart';
import 'package:youtimizer/Widgets/ScreenSelect.dart';
import 'package:youtimizer/Modal/HomeData.dart';
import 'package:youtimizer/Widgets/CustomGraph.dart';
import 'package:youtimizer/Pages/PdfView.dart';

final bgColor = const Color(0xff99cc33);

class Home extends StatefulWidget {
  int uid;

  Home({this.uid});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }
}

class HomeState extends State<Home> {
  Shared shared = Shared();
  Authentication authentication = Authentication();
  String address;
  bool inProgress = true;
  GraphData graphData = GraphData(y: [], x: []);
  List<String> year = [];
  List<String> performance = [];
  List<String> x = [];
  List<double> y = [];
  List<String> amount = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchYear();
    fetchGraph();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  fetchYear() async {
    authentication.fetchYearData().then((res) {
      print("Year");
      print(res);

      for (var i = 0; i < res['year'].length; i++) {
        performance.add(res['performance'][i]);
        year.add(res['year'][i]);
      }
      setState(() {
        performance = performance;
        year = year;
      });
      print("Year ${year}");
    });
  }

  fetchGraph() async {
    authentication.fetchGraphData(widget.uid).then((res) {
      print("GRAPH");
      print(res);

      for (var i = 0; i < res['y-axes'].length; i++) {
        y.add(double.parse(res['y-axes'][i]));
        x.add((res['x-axes'][i]).toString());
        amount.add((res['amount'][i]).toString());
      }
      setState(() {
        x = x;
        y = y;
        amount= amount;
        inProgress = false;
      });
      print("Y ${y}");
    });
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
          : x != null
              ? HomeView(
                  x: x,
                  y: y,
                  address: address,
                  year: year,
                  performance: performance,
                  amount: amount,
                  uid: widget.uid,
                  parent: this,
                )
              : Container(
                  child: Center(
                    child: Text("No data found",style: TextStyle(color: Colors.white),),
                  )
                ),
    );
  }
}

class HomeView extends StatelessWidget {
  // HomeData homeData;
  String address;
  List<String> x = [];
  List<double> y = [];
  List<String> amount = [];
  List<String> year = [];
  List<String> performance = [];
  HomeState parent;
  int uid;
  Authentication authentication = Authentication();


  HomeView({this.x, this.y, this.address, this.performance, this.year, this.amount, this.parent, this.uid});
  // HomeView({this.homeData, this.x, this.y, this.address, this.performance, this.year, this.amount});

  fetchGraph() async {
    authentication.fetchGraphData(uid).then((res) {
      print("GRAPH");
      print(res);

      x = [];
      y = [];
      amount = [];

      for (var i = 0; i < res['y-axes'].length; i++) {
        y.add(double.parse(res['y-axes'][i]));
        x.add((res['x-axes'][i]).toString());
        amount.add((res['amount'][i]).toString());
      }
      this.parent.setState(() {
        this.parent.x = x;
        this.parent.y = y;
        this.parent.amount = amount;
      });
      print("Y ${y}");
    });
  }

  fetchYearGraph(String year) async {
    authentication.fetchYearGraphData(uid, year).then((res) {
      print("YearGRAPH");
      print(res);

      x = [];
      y = [];
      amount = [];

      for (var i = 0; i < res['y-axes'].length; i++) {
        y.add(double.parse(res['y-axes'][i]));
        x.add((res['x-axes'][i]).toString());
        amount.add((res['amount'][i]).toString());
      }
      this.parent.setState(() {
        this.parent.x = x;
        this.parent.y = y;
        this.parent.amount = amount;
      });
      print("Y ${y}");
    });
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return ListView(
      addAutomaticKeepAlives: true,
      shrinkWrap: true,
      children: <Widget>[
        Text("My skype address is bolesalavb@gmail.com, can you chat me using Skype?",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        ScreenTitle(title: "Youtimizer Performance"),
        InkWell(
          onTap: () {
            fetchGraph();
          },
          child: ScreenSelect(title: "Default - Last 12 Months"),
        ),
        ListView.builder(
          addAutomaticKeepAlives: true,
          shrinkWrap: true,
          itemCount: year.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                fetchYearGraph(year[index]);
              },
              child: ScreenSelect(title: year[index] + " Performance " + performance[index]),
            );
          }
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          height: 250,
          color: Colors.black54,
          child: CustomGraph(
            x: x,
            y: y,
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.0)),
          height: MediaQuery.of(context).orientation == Orientation.landscape
              ? 200
              : 300,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  addAutomaticKeepAlives: true,

                  children: <Widget>[TableView(x: x, y: y, amount: amount)],
                ),
              )
            ],
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


class TableView extends StatelessWidget {
  // HomeData homeData;
  List<String> x = [];
  List<double> y = [];
  List<String> amount = [];

  TableView({this.x, this.y, this.amount});

  List<TableRow> widgets = [];

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).orientation);
    double flexVal = 1.5;
    if (MediaQuery.of(context).orientation == Orientation.portrait &&
        MediaQuery.of(context).size.width <= 320) {
      flexVal = 1.0;
    }
    for (var i = 0; i < x.length; i++) {
        widgets.add(
          TableRow(
            children: [
              rowDesign(x[i], false, false, context, Alignment.center),
              rowDesign(y[i].toString(), false, false, context, Alignment.centerRight),
              rowDesign(amount[i], false, false, context,
                  Alignment.centerRight),
            ],
          ),
        );
    }

    // TODO: implement build
    return Table(
      columnWidths: {
        0: FlexColumnWidth(0.8),
        1: FlexColumnWidth(flexVal), // - is ok
        // 2: FlexColumnWidth(0.6), //- ok as well
        2: FlexColumnWidth(1.1),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: widgets,
    );
  }

  openPDF(link, BuildContext context) {
    if (link != '') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PDFview(
                link: link,
              ),
        ),
      );
    }
  }

/*
* ,
* */
  Widget rowDesign(String name, bool flag, bool isPdf, BuildContext context,
      Alignment alignment) {
//    print("PDF $name" );
    return Container(
      decoration: BoxDecoration(
        color: flag ? Colors.grey : Colors.transparent,
      ),
      alignment: alignment,
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0, left: 10),
      child: isPdf
          ? name != ''
              ? GestureDetector(
                  onTap: () {
                    openPDF(name, context);
                  },
                  child: Image.asset(
                    "images/pd.png",
                    height: 22.0,
                  ))
              : Container()
          : Text(
              (name == null) ? '-' : name,
              style: TextStyle(
                  color: flag ? Colors.white : Colors.white, fontSize: 11.0),
            ),
    );
  }

  Widget rowPdfDesign(String name, bool flag, bool isPdf, BuildContext context,
      String url, Alignment alignment) {
//    print("PDF $name" );
    return Container(
      decoration: BoxDecoration(
        color: flag ? Colors.grey : Colors.transparent,
      ),
      alignment: alignment,
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 1.0, left: 1),
      child: GestureDetector(
        onTap: () {
          openPDF(url, context);
        },
        child: SafeArea(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                (name == null) ? '-' : name,
                style: TextStyle(
                    color: flag ? Colors.white : Colors.white, fontSize: 12.0),
              ),
              url != ''
                  ? Image.asset(
                      "images/pd.png",
                      height: 20.0,
                      width: 20.0,
                    )
                  : Container(
                      width: 20.0,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
