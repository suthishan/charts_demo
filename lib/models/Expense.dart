import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;

class ExpenseListModel {
  late int amountSpent;
  late int categoryId;
  late String categoryName;
  // charts.Color barColor;

  ExpenseListModel(this.amountSpent, this.categoryId, this.categoryName);

  ExpenseListModel.fromJson(Map<String, dynamic> json) {
    amountSpent = json['AmountSpent'];
    categoryId = json['CategoryId'];
    categoryName = json['CategoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AmountSpent'] = this.amountSpent;
    data['CategoryId'] = this.categoryId;
    data['CategoryName'] = this.categoryName;
    return data;
  }
}
