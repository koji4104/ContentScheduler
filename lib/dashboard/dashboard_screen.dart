
import 'package:flutter/material.dart';

import 'constants.dart';
import 'chart_panel.dart';
import 'detail_panel.dart';
import 'progress_panel.dart';
import 'responsive.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      ProgressPanel(),
                      SizedBox(height: defaultPadding),
                      DetailPanel(),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) ChartPanel(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we dont want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: ChartPanel(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
