import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class VerticalPaginatedGridViewBuilder<T> extends StatefulWidget {
  List<T> list;
  Widget Function(T item) widget;
  VoidCallback updateList;
  VoidCallback onRefresh;
  EdgeInsets? padding;

  VerticalPaginatedGridViewBuilder(
      {super.key,
      required this.list,
      required this.updateList,
      required this.onRefresh,
      required this.widget,
      this.padding});

  @override
  State<VerticalPaginatedGridViewBuilder<T>> createState() =>
      _VerticalPaginatedGridViewBuilderState<T>();
}

class _VerticalPaginatedGridViewBuilderState<T>
    extends State<VerticalPaginatedGridViewBuilder<T>> {
  Widget? emptyListWidget;

  ScrollController controller = ScrollController();
  @override
  void initState() {
    controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: widget.list.isEmpty ? buildEmptyList : buildList,
    );
  }

  Widget get buildList {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 3.2.h),
      ),
      padding: widget.padding,
      itemCount: widget.list.length,
      shrinkWrap: true,
      controller: controller,
      itemBuilder: (context, index) => widget.widget(widget.list[index]),
    );
  }

  Widget get buildEmptyList {
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 1.7),
      ),
      shrinkWrap: true,
      children: const [
        SizedBox(),
      ],
    );
  }

  Future<void> _refresh() async {
    widget.onRefresh();
  }

  void _scrollListener() {
    if (!controller.hasClients) return;
    if (controller.position.maxScrollExtent == controller.offset) {
      widget.updateList();
    }
  }
}
