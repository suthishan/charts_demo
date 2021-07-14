import 'dart:convert';

import 'package:charts_task/models/Expense.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class PieChart extends StatefulWidget {
  PieChart({Key? key}) : super(key: key);

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  bool isLoaded = false;

  List<ExpenseListModel> reportlistmodel = [];
  List expenseResult = [];

  final data = [
    GradesData('A', 190),
    GradesData('B', 230),
    GradesData('C', 150),
    GradesData('D', 73),
    GradesData('E', 31),
    GradesData('Fail', 13),
  ];

  @override
  void initState() {
    super.initState();
    getLoadData();
    getexpensedata();
    setOnlyPortrait();
  }

  void getLoadData() {
    Future.delayed(const Duration(milliseconds: 5000), () {
      setState(() {
        isLoaded = true;
      });
    });
  }

  Future<List<ExpenseListModel>> getexpensedata() async {
    final url = "http://65.1.73.181:3001/api/v1.0/master/CategoryStatistics";

    var bodyValue =
        jsonEncode({'FromDate': "2021-06-09", 'ToDate': "2021-06-10"});
    // try {
    final response = await http.post(Uri.parse(url), body: bodyValue);
    final responseJson = json.decode(response.body);
    print(responseJson);
    var responseGalleryData = responseJson['responseData'];
    expenseResult = responseGalleryData;
    setState(() {
      for (var data in expenseResult) {
        reportlistmodel.add(new ExpenseListModel(
            data['AmountSpent'], data['CategoryId'], data['CategoryName']));
        // repo_data = true;
      }
    });
    return expenseResult
        .map<ExpenseListModel>((json) => new ExpenseListModel.fromJson(json))
        .toList();
  }

  void setOnlyPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  _getSeriesData() {
    List<charts.Series<GradesData, String>> series = [
      charts.Series(
          id: "Expense",
          data: data,
          domainFn: (GradesData series, _) => series.gradeSymbol,
          measureFn: (GradesData series, _) => series.numberOfStudents,
          colorFn: (GradesData series, _) =>
              charts.ColorUtil.fromDartColor(Colors.lightBlue))
    ];
    return series;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bar Chart Example'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          height: 400,
          padding: EdgeInsets.all(20),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    "Pie Chart",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  isLoaded
                      ? Expanded(
                          child: charts.PieChart(
                            _getSeriesData(),
                            animate: true,
                            defaultRenderer: new charts.ArcRendererConfig(
                                arcWidth: 60,
                                arcRendererDecorators: [
                                  new charts.ArcLabelDecorator()
                                ]),
                          ),
                        )
                      : Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GradesData {
  final String gradeSymbol;
  final int numberOfStudents;

  GradesData(this.gradeSymbol, this.numberOfStudents);
}
