import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XO Game',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'XO Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const double RADIUS_CORNER = 12;
  static const int NONE = 0;
  static const int VALUE_X = 1;
  static const int VALUE_O = 2;

  /// Theme game
  Color colorBorder = Colors.green[600];
  Color colorBackground = Colors.green[100];
  Color colorBackgroundChannelNone = Colors.green[200];
  Color colorBackgroundChannelValueX = Colors.green[400];
  Color colorBackgroundChannelValueO = Colors.green[400];
  Color colorChannelIcon = Colors.green[800];
  Color colorTextCurrentTurn = Colors.green[900];

  // State of Game
  List<List<int>> channelStatus = [
    [NONE, NONE, NONE],
    [NONE, NONE, NONE],
    [NONE, NONE, NONE],
  ];

  //
  int currentTurn = VALUE_X;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(constraints: BoxConstraints.expand(),
            color: colorBackground,
            child: Center(
                child: Column(mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Turn of player",
                          style: TextStyle(
                              fontSize: 36, color: colorTextCurrentTurn,
                              fontWeight: FontWeight.bold)),
                      Icon(getIconFromStatus(currentTurn), size: 60, color: colorChannelIcon),
                      Container(
                          margin: EdgeInsets.only(top: 12),
                          decoration: BoxDecoration(
                              color: colorBorder,
                              borderRadius: BorderRadius.all(Radius.circular(8))),
                          padding: EdgeInsets.all(12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: buildRowChannel(0)),
                              Row(mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: buildRowChannel(1)),
                              Row(mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: buildRowChannel(2))
                            ],
                          ))
                    ])))
    );
  }

  List<Widget> buildRowChannel(int row) {
    List<Widget> listWidget = List();
    for (int col = 0; col < 3; col++) {
      double tlRadius = row == 0 && col == 0 ? RADIUS_CORNER : 0;
      double trRadius = row == 0 && col == 2 ? RADIUS_CORNER : 0;
      double blRadius = row == 2 && col == 0 ? RADIUS_CORNER : 0;
      double brRadius = row == 2 && col == 2 ? RADIUS_CORNER : 0;
      Widget widget = buildChannel(
          row,
          col,
          tlRadius,
          trRadius,
          blRadius,
          brRadius,
          channelStatus[row][col]);
      listWidget.add(widget);
    }
    return listWidget;
  }

  Widget buildChannel(int row,
      int col,
      double tlRadius,
      double trRadius,
      double blRadius,
      double brRadius,
      int status) =>
      GestureDetector(onTap: () => onChannelPressed(row, col),
          child: Container(
              margin: EdgeInsets.all(2),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  color: getBackgroundChannelFromStatus(status),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(tlRadius),
                      topRight: Radius.circular(trRadius),
                      bottomLeft: Radius.circular(blRadius),
                      bottomRight: Radius.circular(brRadius)
                  )),
              child: Icon(getIconFromStatus(status), size: 60, color: colorChannelIcon)));

  IconData getIconFromStatus(int status) {
    if (status == VALUE_X) {
      return Icons.close;
    } else if (status == VALUE_O) {
      return Icons.radio_button_unchecked;
    }
    return null;
  }

  Color getBackgroundChannelFromStatus(int status) {
    if (status == VALUE_X) {
      return colorBackgroundChannelValueX;
    } else if (status == VALUE_O) {
      return colorBackgroundChannelValueO;
    }
    return colorBackgroundChannelNone;
  }

  onChannelPressed(int row, int col) {
    if (channelStatus[row][col] == NONE) {
      setState(() {
        channelStatus[row][col] = currentTurn;

        if (isGameEndedByWin()) {
          showEndGameDialog(currentTurn);
        } else {
          if(isGameEndedByDraw()){
            showEndGameByDrawDialog();
          }else {
            switchPlayer();
          }
        }
      });
    }
  }

  void switchPlayer() {
    setState(() {
      if (currentTurn == VALUE_X) {
        currentTurn = VALUE_O;
      } else if (currentTurn == VALUE_O) {
        currentTurn = VALUE_X;
      }
    });
  }

  bool isGameEndedByDraw() {
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if(channelStatus[row][col] == NONE){
          return false;
        }
      }
    }
    return true;
  }

  bool isGameEndedByWin() {
    // check vertical.
    for (int col = 0; col < 3; col++) {
      if (channelStatus[0][col] != NONE &&
          channelStatus[0][col] == channelStatus[1][col] &&
          channelStatus[1][col] == channelStatus[2][col]) {
        return true;
      }
    }

    // check horizontal.
    for (int row = 0; row < 3; row++) {
      if (channelStatus[row][0] != NONE &&
          channelStatus[row][0] == channelStatus[row][1] &&
          channelStatus[row][1] == channelStatus[row][2]) {
        return true;
      }
    }

    // check cross left to right.
    if (channelStatus[0][0] != NONE &&
        channelStatus[0][0] == channelStatus[1][1] &&
        channelStatus[1][1] == channelStatus[2][2]) {
      return true;
    }

    // check cross right to left.
    if (channelStatus[0][2] != NONE &&
        channelStatus[0][2] == channelStatus[1][1] &&
        channelStatus[1][1] == channelStatus[2][0]) {
      return true;
    }

    return false;
  }

  void showEndGameDialog(int winner) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            content: Column(mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("The winner is", style: TextStyle(
                      fontSize: 32,
                      color: colorTextCurrentTurn,
                      fontWeight: FontWeight.bold)),
                  Icon(getIconFromStatus(currentTurn),
                      size: 60,
                      color: colorChannelIcon),
                  RaisedButton(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    color: Colors.yellow[800],
                    child: Text("Play again",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      playAgain();
                      Navigator.of(context).pop();
                    },
                  )
                ])
        );
      },
    );
  }
  void showEndGameByDrawDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            content: Column(mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Draw", style: TextStyle(
                      fontSize: 32,
                      color: colorTextCurrentTurn,
                      fontWeight: FontWeight.bold)),
                  RaisedButton(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    color: Colors.yellow[800],
                    child: Text("Play again",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      playAgain();
                      Navigator.of(context).pop();
                    },
                  )
                ])
        );
      },
    );
  }

  playAgain() {
    setState(() {
      currentTurn = VALUE_X;
      channelStatus = [
        [NONE, NONE, NONE],
        [NONE, NONE, NONE],
        [NONE, NONE, NONE],
      ];
    });
  }
}
