import 'package:flutter/material.dart';
import 'package:flutter_deneme_takip/core/constants/lesson_list.dart';
import 'package:flutter_deneme_takip/core/notifier/tabbar_navigation_notifier.dart';
import 'package:flutter_deneme_takip/view/insert_deneme_view.dart';
import 'package:provider/provider.dart';

class DenemeEditTabbarView extends StatefulWidget {
  final List<String>? denemeSubjectList;
  final List<String>? lessonNameList;
  const DenemeEditTabbarView(
      {Key? key, this.denemeSubjectList, this.lessonNameList})
      : super(key: key);

  @override
  State<DenemeEditTabbarView> createState() => _DenemeTabbarViewState();
}

class _DenemeTabbarViewState extends State<DenemeEditTabbarView>
    with TickerProviderStateMixin {
  late TabController tabController;
  late List<String> denemeSubjectList;
  late List<String>? lessonNameList;
  @override
  void initState() {
    denemeSubjectList = lessonNameList = LessonList.lessonNameList;
    super.initState();

    tabController = TabController(length: lessonNameList!.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabbarNavProv = Provider.of<TabbarNavigationProvider>(context);

    return DefaultTabController(
      length: LessonList.lessonNameList.length,
      initialIndex: tabbarNavProv.getCurrentEditDeneme,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            tabbarNavProv.setCurrentEditDeneme = tabController.index;
          }
        });
        return Scaffold(
          appBar: AppBar(
            title: const Center(
                child:
                    Text(style: TextStyle(color: Colors.white), 'Deneme App')),
            backgroundColor: const Color(0xff1c0f45),
            bottom: const TabBar(
                indicatorColor: Colors.greenAccent,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [
                  Tab(text: "Tarih"),
                  Tab(text: "Coğrafya"),
                  Tab(text: "Vatandaşlık"),
                  Tab(text: "Matematik"),
                  Tab(text: "Türkçe"),
                ]),
          ),
          body: const TabBarView(
            children: [
              InsertDeneme(
                  lessonName: "Tarih", subjectList: LessonList.historySubjects),
              InsertDeneme(
                lessonName: "Coğrafya",
                subjectList: LessonList.cografySubject,
              ),
              InsertDeneme(
                lessonName: "Vatandaşlık",
                subjectList: LessonList.vatandasSubject,
              ),
              InsertDeneme(
                lessonName: "Matematik",
                subjectList: LessonList.mathSubject,
              ),
              InsertDeneme(
                lessonName: "Türkçe",
                subjectList: LessonList.turkceSubject,
              ),
            ],
          ),
        );
      }),
    );
  }
}
