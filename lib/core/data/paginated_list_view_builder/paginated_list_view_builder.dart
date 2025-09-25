import 'package:flutter/material.dart';

// ignore: must_be_immutable
class VerticalPaginatedListViewBuilder<T> extends StatelessWidget {
  List<T> list;
  Widget Function(T item) widget;
  VoidCallback updateList;
  VoidCallback onRefresh;
  EdgeInsets? padding;
  Widget? emptyListWidget;
  ScrollController controller = ScrollController();
  VerticalPaginatedListViewBuilder({
    super.key,
    required this.list,
    required this.updateList,
    required this.onRefresh,
    required this.widget,
    this.padding,
  }) {
    controller.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: list.isEmpty ? buildEmptyList : buildList,
    );
  }

  Widget get buildList {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: padding,
      itemCount: list.length,
      shrinkWrap: true,
      controller: controller,
      itemBuilder: (context, index) => widget(list[index]),
    );
  }

  Widget get buildEmptyList {
    return ListView(
      shrinkWrap: true,
      children: const [
        SizedBox(),
      ],
    );
  }

  Future<void> _refresh() async {
    onRefresh();
  }

  void _scrollListener() {
    if (!controller.hasClients) return;
    if (controller.position.maxScrollExtent == controller.offset) {
      updateList();
    }
  }
}
