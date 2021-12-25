import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'responsive.dart';
import 'progress_sample.dart';
import 'progress_model.dart';
import 'constants.dart';
import '../schedule_provider.dart';

class ProgressPanel extends StatelessWidget {
  const ProgressPanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Responsive(
          mobile: ProgressGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 ? 1.3 : 1,
          ),
          tablet: ProgressGridView(),
          desktop: ProgressGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class ProgressGridView extends StatelessWidget {
  const ProgressGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: progressList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => ProgressItem(data: progressList[index]),
    );
  }
}

class ProgressItem extends ConsumerWidget {
  const ProgressItem({
    Key? key,
    required this.data,
  }) : super(key: key);

  final ProgressData data;

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(defaultPadding * 0.75),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Color(data.col).withOpacity(0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child:
                Icon(Icons.insert_drive_file_outlined, size:16),
              ),
              Icon(Icons.more_vert, color: col.panelFgColor)
            ],
          ),
          Text(
            data.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          ProgressLine(
            color: Color(data.col),
            percentage: (100*data.value/data.total).toInt(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${data.value} Files",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: col.panelFgColor),
              ),
              Text(
                data.total.toString(),
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: col.panelFgColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}

