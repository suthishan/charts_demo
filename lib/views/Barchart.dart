import 'dart:convert';

import 'package:charts_task/models/Expense.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class BarChart extends StatefulWidget {
  BarChart({Key? key}) : super(key: key);

  @override
  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  bool isLoaded = false;

  List<ExpenseListModel> reportlistmodel = [];
  List expenseResult = [];

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
    print("reportlistmodel");
    print(reportlistmodel);

    List<charts.Series<ExpenseListModel, String>> series = [
      charts.Series(
          id: "Expense",
          data: reportlistmodel,
          domainFn: (ExpenseListModel series, _) => series.categoryName,
          measureFn: (ExpenseListModel series, _) => series.amountSpent,
          colorFn: (ExpenseListModel series, _) =>
              charts.ColorUtil.fromDartColor(Colors.lightBlue))
    ];
    print(series);
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
                    "Expense Chart",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  isLoaded
                      ? Expanded(
                          child: charts.BarChart(
                            _getSeriesData(),
                            animate: true,
                            domainAxis: charts.OrdinalAxisSpec(
                                renderSpec: charts.SmallTickRendererSpec(
                                    labelRotation: 60)),
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
