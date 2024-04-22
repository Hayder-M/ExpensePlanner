import 'dart:io';
import 'dart:convert';

import 'package:expense_planner/models/transaction.dart';
import 'package:expense_planner/widgets/chart.dart';
import 'package:expense_planner/widgets/new_transaction.dart';
import 'package:expense_planner/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  /* WidgetsFlutterBinding.ensureInitialized();  // pour forcer lapp tekhdem ken all portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);*/
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'QuickSand',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    /*Transaction(
        id: 't1', title: "New Shoes", amount: 69.99, date: DateTime.now()),
    Transaction(
        id: 't2',
        title: "Weekly Groceries",
        amount: 16.59,
        date: DateTime.now()),*/
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTx = Transaction(
        title: title,
        amount: amount,
        date: chosenDate,
        id: DateTime.now().toString());

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    
    //user cupertino for the appBar
    /*final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Personal Expenses',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            title: Text(
              'Personal Expenses',
            ),
            actions: [
              IconButton(
                onPressed: () => _startAddNewTransaction(context),
                icon: Icon(Icons.add),
                color: Colors.blue,
              )
            ],
          );*/

          final appBar = AppBar(
      title: Text(
        'Personal Expenses',
      ),
      actions: [
        IconButton(
          onPressed: () => _startAddNewTransaction(context),
          icon: Icon(Icons.add),
          color: Colors.blue,
        )
      ],
    );

    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding
                    .top) * //MediaQuery.of(context).padding.top na7ina biha l espace zeyed
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));

    final pageBody = SafeArea(child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text("Show Chart ",
                style: Theme.of(context).textTheme.titleLarge,),
                Switch.adaptive(
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    })
              ],
            ),
          if (!isLandscape)
            Container(
                // hne gotlo if showChart==true yaffihci chart sinon le
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding
                            .top) * //preferredSize.height nekho biha l height ta3 l app bar
                    0.3,
                child: Chart(_recentTransactions)),
          if (!isLandscape) txListWidget,
          if (isLandscape)
            _showChart
                ? Container(
                    // hne gotlo if showChart==true yaffihci chart sinon le
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                            mediaQuery.padding
                                .top) * //preferredSize.height nekho biha l height ta3 l app bar
                        0.7,
                    child: Chart(_recentTransactions))
                : txListWidget
        ],
      ),
    ),
    );

//user Cupertino for appBar
   /* return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: Platform
                    .isIOS // lehna gotlo idha nesta3eml f ios meghir me nafficher l button loutaneya ta3 l add
                ? Container()
                : FloatingActionButton(
                    child: Icon(
                      Icons.add,
                      color: Colors.blue,
                    ),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );*/
    return Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: Platform
                    .isIOS // lehna gotlo idha nesta3eml f ios meghir me nafficher l button loutaneya ta3 l add
                ? Container()
                : FloatingActionButton(
                    child: Icon(
                      Icons.add,
                      color: Colors.blue,
                    ),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );

  }
}
