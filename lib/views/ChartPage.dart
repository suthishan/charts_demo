import 'package:charts_task/views/Barchart.dart';
import 'package:charts_task/views/PieChart.dart';
import 'package:flutter/material.dart';

import 'DonutCharts.dart';

class ChartsPage extends StatefulWidget {
  ChartsPage({Key? key}) : super(key: key);

  @override
  _ChartsPageState createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  Widget _buildCard(String assetUrl, String title, int index) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: deviceHeight * 0.45,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: InkWell(
          onTap: () {
            if (index == 1) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => BarChart()));
            } else if (index == 2) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DonutCharts()));
            } else if (index == 3) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => PieChart()));
            }
          },
          child: Stack(
            children: <Widget>[
              Container(
                height: deviceHeight * 0.3,
                decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        colorFilter: new ColorFilter.mode(
                            Colors.black.withOpacity(0.7), BlendMode.dstATop),
                        image: AssetImage(assetUrl))),
              ),
              Container(
                margin: EdgeInsets.only(top: deviceHeight * 0.125),
                alignment: Alignment.center,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 29),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Chart"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 25,
            ),
            _buildCard('assets/images/barchart.jpg', 'Bar-Chart', 1),
            SizedBox(
              height: 25,
            ),
            _buildCard('assets/images/donut.jpg', 'Donut Chart', 2),
            SizedBox(
              height: 25,
            ),
            _buildCard('assets/images/piechart.jpg', 'Pie-Chart', 3)
          ],
        ),
      ),
    );
  }
}
