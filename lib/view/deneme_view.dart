// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_deneme_takip/core/constants/lesson_list.dart';
import 'package:flutter_deneme_takip/components/utils.dart';
import 'package:flutter_deneme_takip/core/extensions/context_extensions.dart';
import 'package:flutter_deneme_takip/core/local_database/deneme_db_provider.dart';
import 'package:flutter_deneme_takip/core/local_database/deneme_tables.dart';

class DenemeView extends StatefulWidget {
  final String? lessonName;

  const DenemeView({Key? key, this.lessonName}) : super(key: key);

  @override
  State<DenemeView> createState() => _DenemeViewState();
}

class _DenemeViewState extends State<DenemeView> {
  late String _lessonName;

  late List<dynamic> rowData;
  late List<dynamic> columnData;

  List<Map<String, dynamic>> denemelerData = [];
  late int k;

  @override
  void initState() {
    print('init');
    super.initState();

    _lessonName = widget.lessonName!;

    columnData = List.of(findList(_lessonName));
    rowData = List.generate(columnData.length,
        (index) => {'row': List.filled(columnData.length, 0), 'isRow': true});
    k = -1;
  }

  String initTable() {
    String tableName =
        LessonList.tableNames[_lessonName] ?? DenemeTables.historyTableName;
    return tableName;
  }

  List<Map<String, dynamic>> filterByDenemeId(List<Map<String, dynamic>> data) {
    Map<int, List<Map<String, dynamic>>> groupedData = {};
    List<Map<String, dynamic>> group = [];

    group.clear();
    groupedData.clear();
    denemelerData.clear();
    for (var item in data) {
      final denemeId = item['denemeId'] as int;
      if (!groupedData.containsKey(denemeId)) {
        groupedData[denemeId] = [];
      }
      groupedData[denemeId]!.add(item);
    }

    //_lastDenemeId =
    //  (await DenemeDbProvider.db.getFindLastId(initTable(), "denemeId"))!;
    //print(_lastDenemeId);
    // group = groupedData[1]!;

    group.addAll(groupedData.values.expand((items) => items));
    return group;
  }

  void convertToRow(List<Map<String, dynamic>> data) async {
    Map<int, List<Map<String, dynamic>>> idToRowMap = {};

    for (var item in filterByDenemeId(data)) {
      int id = item['id'];
      if (idToRowMap[id] == null) {
        idToRowMap[id] = [];
      }
      idToRowMap[id]!.add(item);
    }

    for (var entry in idToRowMap.entries) {
      Map<String, dynamic> rowItem = {"row": entry.value};
      denemelerData.add(rowItem);
    }
    print('denemelerData');
    print(denemelerData);
    print('denemelerData');
  }

  Map<int, List<int>> falseCountsByDenemeId(
      List<Map<String, dynamic>> denemelerData) {
    Map<int, List<int>> falseCountsByDenemeId = {};

    for (var item in denemelerData) {
      var row = item['row'] as List<dynamic>;
      if (row.isNotEmpty) {
        var denemeId = row[0]['denemeId'] as int;
        var falseCount = row[0]['falseCount'] as int;

        if (!falseCountsByDenemeId.containsKey(denemeId)) {
          falseCountsByDenemeId[denemeId] = [];
        }

        falseCountsByDenemeId[denemeId]!.add(falseCount);
      }
    }
    return falseCountsByDenemeId;
  }

  void insertRowData(List<Map<String, dynamic>> denemelerData) {
    int i = 0;
    falseCountsByDenemeId(denemelerData).forEach((denemeId, falseCounts) {
      List<dynamic> arr = List.generate(columnData.length, (index) => 0);
      print('denemeId: $denemeId, falseCounts: $falseCounts');
      print('falseCounts[$i] $falseCounts');
      print("col length ${columnData.length}");
      print("row length ${rowData.length}");
      print("falseCounts length ${falseCounts.length}");
      print("arr length ${arr.length}");

      for (int j = 0; j < (falseCounts.length); j++) {
        arr[0] = "Deneme${i + 1}";
        arr[j] = falseCounts[j];
        print('arrx[$j] = ${falseCounts[j]}');
      }

      rowData[i] = {'row': List.from(arr), 'isRow': k != 0};
      print('rowData[$i] = ${rowData[i]}');
      print('arr[$i] = ${arr[i]}');

      i++;
      arr.clear();
    });
    print("rowx");
    print(rowData);
    print("rowx");
  }

  List<String> findList(String lessonName) {
    return LessonList.lessonListMap[lessonName] ?? [];
  }

  Future<List<Map<String, dynamic>>> initData() async {
    String tableName =
        LessonList.tableNames[_lessonName] ?? DenemeTables.historyTableName;

    //DenemeViewModel().getAllData(tableName);

    return await DenemeDbProvider.db.getLessonDeneme(tableName);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initData(),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          convertToRow(snapshot.data!);
          insertRowData(denemelerData);

          return Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 20,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: buildDataTable(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildDataTable() {
    return Center(
        child: Column(children: <Widget>[
      SizedBox(
        child: Table(
          defaultColumnWidth: const FixedColumnWidth(61.0),
          border: TableBorder.all(
              color: Colors.black, style: BorderStyle.solid, width: 1),
          children: [getColumns(), ...getRows()],
        ),
      ),
    ]));
  }

  TableRow getColumns() {
    List<Map<String, dynamic>> columnXdata = List.from(rowData);

    return TableRow(
      children: Utils.modelBuilder(
        columnXdata,
        (i, column) {
          return Padding(
            padding: const EdgeInsets.all(0.4),
            child: Column(
              children: [
                i == 0
                    ? Container(
                        height: 100,
                        width: 200,
                        decoration: const BoxDecoration(
                          color: Color(0xff1c0f45),
                        ),
                        child: const Center(
                          child: Text(
                            "Deneme Sıra No",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: 100,
                        width: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image:
                              AssetImage('assets/img/table_columns/hs/$i.png'),
                          fit: BoxFit.fill,
                          repeat: ImageRepeat.noRepeat,
                        ))),
              ],
            ),
          );
        },
      ),
    );
  }

  List<TableRow> getRows() {
    k = -1;
    List<Map<String, dynamic>> rowXdata = List.from(rowData);
    double denemeNum = 1;
    return rowXdata.map((row) {
      return TableRow(
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black, style: BorderStyle.solid, width: 0.5),
        ),
        children: Utils.modelBuilder(row['row'], (i, cell) {
          k >= 99 ? k = -1 : k;
          k++;
          denemeNum = (((k - 11) ~/ 11) + 2);

          i == 0 ? print("k $k :  ${denemeNum.toStringAsFixed(0)}") : "";
          return Ink(
            color:
                row['isRow'] && i != 0 ? Colors.white : const Color(0xff060644),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: context.dynamicH(0.00714)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      i == 0
                          ? Center(
                              child: Container(
                                color: const Color(0xff060644),
                                child: Text(
                                  denemeNum < 11 && k != 10
                                      ? 'Deneme ${denemeNum.toStringAsFixed(0)}'
                                      : k == 10
                                          ? 'Deneme 11'
                                          : "",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    backgroundColor: Color(0xff060644),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(cell.toString(),
                                  textAlign: TextAlign.center,
                                  style: row['isRow'] && i != 0
                                      ? const TextStyle(color: Colors.black)
                                      : const TextStyle(color: Colors.white)),
                            ),
                    ]),
              ),
            ),
          );
        }),
      );
    }).toList();
  }
}
