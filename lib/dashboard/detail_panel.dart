import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'detail_sample.dart';
import 'detail_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../schedule_provider.dart';

class DetailPanel extends ConsumerWidget {
  const DetailPanel({
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
            "Recent Files",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable2(
              columnSpacing: defaultPadding,
              minWidth: 600,
              columns: [
                DataColumn(label: Text("File Name")),
                DataColumn(label: Text("Date")),
                DataColumn(label: Text("Size")),
              ],
              rows: List.generate(
                detailList.length,
                (index) => DetailDataRow(detailList[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow DetailDataRow(DetailData fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Icon(Icons.insert_drive_file_outlined, size:30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(fileInfo.name),
            ),
          ],
        ),
      ),
      DataCell(Text(fileInfo.date)),
      DataCell(Text(fileInfo.size)),
    ],
  );
}
