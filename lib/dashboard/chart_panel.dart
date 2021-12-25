import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'constants.dart';
import '../schedule_provider.dart';

class ChartPanel extends ConsumerWidget {
  const ChartPanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final col = ref.watch(colorProvider);
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: col.panelBgColor,
        borderRadius: const BorderRadius.all(Radius.circular(3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Storage Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(),
          ChartInfo(
            title: "Documents Files",
            amountOfFiles: "1.3GB",
            numOfFiles: 1328,
          ),
          ChartInfo(
            title: "Media Files",
            amountOfFiles: "15.3GB",
            numOfFiles: 1328,
          ),
          ChartInfo(
            title: "Other Files",
            amountOfFiles: "1.3GB",
            numOfFiles: 1328,
          ),
          ChartInfo(
            title: "Unknown",
            amountOfFiles: "1.3GB",
            numOfFiles: 140,
          ),
        ],
      ),
    );
  }
}

class ChartInfo extends ConsumerWidget {
  const ChartInfo({
    Key? key,
    required this.title,
    required this.amountOfFiles,
    required this.numOfFiles,
  }) : super(key: key);

  final String title, amountOfFiles;
  final int numOfFiles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final col = ref.watch(colorProvider);
    return Container(
      margin: EdgeInsets.only(top: defaultPadding),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: Icon(Icons.insert_chart),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "$numOfFiles Files",
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: col.panelFgColor),
                  ),
                ],
              ),
            ),
          ),
          Text(amountOfFiles)
        ],
      ),
    );
  }
}

class Chart extends ConsumerWidget {
  const Chart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final col = ref.watch(colorProvider);
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: paiChartSelectionDatas,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: defaultPadding),
                Text(
                  "29.1",
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: col.panelFgColor,
                    fontWeight: FontWeight.w600,
                    height: 0.5,
                  ),
                ),
                Text("of 128GB")
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<PieChartSectionData> paiChartSelectionDatas = [
  PieChartSectionData(
    color: primaryColor,
    value: 25,
    showTitle: false,
    radius: 25,
  ),
  PieChartSectionData(
    color: Color(0xFF26E5FF),
    value: 20,
    showTitle: false,
    radius: 22,
  ),
  PieChartSectionData(
    color: Color(0xFFFFCF26),
    value: 10,
    showTitle: false,
    radius: 19,
  ),
  PieChartSectionData(
    color: Color(0xFFEE2727),
    value: 15,
    showTitle: false,
    radius: 16,
  ),
  PieChartSectionData(
    color: primaryColor.withOpacity(0.1),
    value: 25,
    showTitle: false,
    radius: 13,
  ),
];
