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
import 'package:intl/intl.dart';

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
  List<String> total_percent = [];
  List<bool> btnColor = [];
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

      btnColor.add(true);
      for (var i = 0; i < res['year'].length; i++) {
        performance.add(res['performance'][i]);
        year.add(res['year'][i]);
        btnColor.add(false);
      }
      setState(() {
        performance = performance;
        year = year;
        btnColor = btnColor;
      });
      print("btnColor ${btnColor}");
    });
  }

  fetchGraph() async {
    authentication.fetchGraphData(widget.uid).then((res) {
      print("GRAPH");
      print(res);

      for (var i = 0; i < res['y-axes'].length; i++) {
        y.add(double.parse(res['y-axes'][i]));
        x.add((res['x-axes'][i]).toString());
        total_percent.add((res['total percent'][i]).toString());
      }
      setState(() {
        x = x;
        y = y;
        total_percent= total_percent;
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
                  total_percent: total_percent,
                  uid: widget.uid,
                  parent: this,
                  btnColor: btnColor,
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
  List<String> total_percent = [];
  List<String> year = [];
  List<String> performance = [];
  HomeState parent;
  int uid;
  Authentication authentication = Authentication();
  List<bool> btnColor = [];

  HomeView({this.x, this.y, this.address, this.performance, this.year, this.total_percent, this.parent, this.uid, this.btnColor});

   List<TableRow> widgets = [];

  fetchGraph() async {
    authentication.fetchGraphData(uid).then((res) {
      print("GRAPH");
      print(res);

      x = [];
      y = [];
      total_percent = [];

      for (var i = 0; i < res['y-axes'].length; i++) {
        y.add(double.parse(res['y-axes'][i]));
        x.add((res['x-axes'][i]).toString());
        total_percent.add((res['total percent'][i]).toString());
      }
      this.parent.setState(() {
        this.parent.x = x;
        this.parent.y = y;
        this.parent.total_percent = total_percent;
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
      total_percent = [];

      for (var i = 0; i < res['y-axes'].length; i++) {
        y.add(double.parse(res['y-axes'][i]));
        x.add((res['x-axes'][i]).toString());
        total_percent.add((res['total percent'][i]).toString());
      }
      this.parent.setState(() {
        this.parent.x = x;
        this.parent.y = y;
        this.parent.total_percent = total_percent;
      });
      print("Y ${y}");
    });
  }

  @override
  Widget build(BuildContext context) {

    widgets = [];
    widgets.add(
      TableRow(
        children: [
          rowDesign('Date', true, Alignment.center),
          rowDesign('Percent', true, Alignment.centerRight),
          rowDesign('Total Percent', true, Alignment.centerRight),
        ],
      ),
    );
    
    double flexVal = 1.5;
    if (MediaQuery.of(context).orientation == Orientation.portrait &&
        MediaQuery.of(context).size.width <= 320) {
      flexVal = 1.0;
    }
    // TODO: implement build
    return ListView(
      addAutomaticKeepAlives: true,
      shrinkWrap: true,
      children: <Widget>[
        ScreenTitle(title: "Club Performance"),
        InkWell(
          onTap: () {
            fetchGraph();
            btnColor = [];
            btnColor.add(true);
            for (var i = 0; i < year.length; i++) {
              btnColor.add(false);
            }
            this.parent.setState(() {
              this.parent.btnColor = btnColor;
            });
          },
          child: ScreenSelect(title: "Default - Last 12 Months", color: btnColor[0]),
        ),
        ListView.builder(
          addAutomaticKeepAlives: true,
          shrinkWrap: true,
          itemCount: year.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                fetchYearGraph(year[index]);
                btnColor = [];
                btnColor.add(false);
                for (var i = 0; i < year.length; i++) {
                  if (i == index) btnColor.add(true);
                  else btnColor.add(false);
                }
                this.parent.setState(() {
                  this.parent.btnColor = btnColor;
                });
              },
              child: ScreenSelect(title: year[index] + " Performance " + performance[index], color: btnColor[index + 1],),
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
              Table(
                columnWidths: {
                  0: FlexColumnWidth(0.8),
                  1: FlexColumnWidth(flexVal), // - is ok
                  2: FlexColumnWidth(1.1),
                },
                children: widgets,
              ),
              Expanded(
                child: ListView(
                  addAutomaticKeepAlives: true,

                  children: <Widget>[TableView(x: x, y: y, total_percent: total_percent)],
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

  /*
* ,
* */
  Widget rowDesign(String name, bool flag, Alignment alignment) {
    return Container(
      decoration: BoxDecoration(
        color: flag ? Colors.black : Colors.transparent,
      ),
      alignment: alignment,
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0, left: 10.0),
      child: Text(
        (name == null) ? '-' : name,
        style: TextStyle(
            color: flag ? Colors.white : Colors.white, fontSize: 11.0),
      ),
    );
  }
}


class TableView extends StatelessWidget {
  // HomeData homeData;
  List<String> x = [];
  List<double> y = [];
  List<String> total_percent = [];

  TableView({this.x, this.y, this.total_percent});

  List<TableRow> widgets = [];
  var formatter = new DateFormat('dd/MM/yyyy');

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
              rowDesign(formatter.format(DateTime.parse(x[x.length - 1 - i])), false, false, context, Alignment.center),
              rowDesign(y[x.length - 1 - i].toString(), false, false, context, Alignment.centerRight),
              rowDesign(total_percent[x.length - 1 - i], false, false, context,
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
