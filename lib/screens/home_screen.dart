import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zadatak/models/comment_model.dart';
import 'package:zadatak/providers/api_provider.dart';
import 'package:zadatak/services/database_helper.dart';
import 'package:zadatak/widgets/cell_dialog.dart';
import 'dart:io' show Platform;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int present = 0;
  int perPage = 10;

  List<Comment> originalItems = [];
  List<Comment> items = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<ApiProvider>().getComments().then((value) {
          setState(() {
            originalItems.addAll(value);
            items.addAll(originalItems.getRange(present, present + perPage));
            present = present + perPage;
          });
          insertComment();
        }).catchError((error, stackTrace) {
          getComments();
        }));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadMore() {
    setState(() {
      items.addAll(originalItems.getRange(present, present + perPage));
      present = present + perPage;
    });
  }

  insertComment() async {
    for (var element in originalItems) {
      await DBProvider.db.insertComments(element);
    }
  }

  getComments() async {
    await DBProvider.db.getComments().then((value) {
      originalItems.addAll(value);
      setState(() {
        items.addAll(originalItems.getRange(present, present + perPage));
        present = present + perPage;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        child: SafeArea(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                if (items.length < originalItems.length) loadMore();
              }
              return true;
            },
            child: !Platform.isIOS ? android() : ios(),
          ),
        ),
      ),
    );
  }

  Widget android() {
    return RefreshIndicator(
      onRefresh: () => context.read<ApiProvider>().getComments().then((value) {
        setState(() {
          originalItems.addAll(value);
          items.addAll(originalItems.getRange(present, present + perPage));
          present = present + perPage;
        });
      }),
      child: SingleChildScrollView(
        child: Table(
          border: TableBorder.all(color: Colors.black),
          children: List<TableRow>.generate(
            items.length,
            (index) {
              final com = items[index];
              return TableRow(
                children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: () => cellDialog(context, com.name),
                        child: Text(
                          com.name!,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                          onTap: () => cellDialog(context, com.email),
                          child: Text(com.email!, textAlign: TextAlign.center)),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                          onTap: () => cellDialog(context, com.body),
                          child: Text(com.body!, textAlign: TextAlign.center)),
                    ),
                  ),
                ],
              );
            },
            // growable: true,
          ),
        ),
      ),
    );
  }

  Widget ios() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () =>
              context.read<ApiProvider>().getComments().then((value) {
            setState(() {
              originalItems.addAll(value);
              items.addAll(originalItems.getRange(present, present + perPage));
              present = present + perPage;
            });
          }),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Table(
              border: TableBorder.all(color: Colors.black),
              children: List<TableRow>.generate(
                items.length,
                (index) {
                  final com = items[index];
                  return TableRow(
                    children: [
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: InkWell(
                            onTap: () => cellDialog(context, com.name),
                            child: Text(
                              com.name!,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: InkWell(
                              onTap: () => cellDialog(context, com.email),
                              child: Text(com.email!,
                                  textAlign: TextAlign.center)),
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: InkWell(
                              onTap: () => cellDialog(context, com.body),
                              child:
                                  Text(com.body!, textAlign: TextAlign.center)),
                        ),
                      ),
                    ],
                  );
                },
                // growable: true,
              ),
            );
          }, childCount: items.length),
        ),
      ],
    );
  }
}
