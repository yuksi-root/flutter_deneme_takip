import 'package:flutter/material.dart';
import 'package:flutter_deneme_takip/components/sign_button.dart';
import 'package:flutter_deneme_takip/core/constants/lesson_list.dart';
import 'package:flutter_deneme_takip/core/extensions/context_extensions.dart';
import 'package:flutter_deneme_takip/core/notifier/tabbar_navigation_notifier.dart';
import 'package:flutter_deneme_takip/services/auth_service.dart';
import 'package:flutter_deneme_takip/view/deneme_view.dart';
import 'package:flutter_deneme_takip/view_model/deneme_view_model.dart';
import 'package:provider/provider.dart';

class DenemeTabbarView extends StatefulWidget {
  const DenemeTabbarView({super.key});

  @override
  State<DenemeTabbarView> createState() => _DenemeTabbarViewState();
}

class _DenemeTabbarViewState extends State<DenemeTabbarView>
    with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabbarNavProv =
        Provider.of<TabbarNavigationProvider>(context, listen: true);
    final denemeProv = Provider.of<DenemeViewModel>(context, listen: false);

    return DefaultTabController(
      length: LessonList.lessonNameList.length,
      initialIndex: tabbarNavProv.getCurrentDenemeIndex,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            tabbarNavProv.setCurrentDenemeIndex = tabController.index;

            denemeProv.setLessonName =
                LessonList.lessonNameList[tabbarNavProv.getCurrentDenemeIndex];

            denemeProv.initData(
                LessonList.lessonNameList[tabbarNavProv.getCurrentDenemeIndex]);
            //  print(denemeProv.listDeneme);

            denemeProv.setInitPng = LessonList.lessonPngList[
                LessonList.lessonNameList[tabbarNavProv.getCurrentDenemeIndex]];
          }
        });
        return Scaffold(
          appBar: buildAppbar(denemeProv),
          body: TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              LessonList.lessonNameList.length,
              (index) {
                return const DenemeView();
              },
            ),
          ),
        );
      }),
    );
  }

  AppBar buildAppbar(DenemeViewModel denemeProv) {
    return AppBar(
      actions: <Widget>[
        buildBackUpButton(context, denemeProv),
        buildPopupMenu(Icons.more_vert_sharp, denemeProv),
      ],
      title: Center(
          child: Text(
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: context.dynamicW(0.01) * context.dynamicH(0.005)),
              '   Deneme App')),
      backgroundColor: const Color(0xff1c0f45),
      bottom: TabBar(
          indicatorColor: Colors.greenAccent,
          isScrollable: true,
          labelStyle: TextStyle(
            fontSize: context.dynamicW(0.01) * context.dynamicH(0.005),
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: context.dynamicW(0.01) * context.dynamicH(0.005),
          ),
          tabAlignment: TabAlignment.start,
          tabs: tab),
    );
  }

  PopupMenuButton<dynamic> buildPopupMenu(
      IconData icon, DenemeViewModel denemeProv) {
    List<dynamic> groupSizes = [1, 5, 10, 20, 30, 40, 50];
    List<String> options = [
      'tekli',
      '5li',
      '10lu',
      '20li',
      '30lu',
      '40lı',
      '50li'
    ];
    List<PopupMenuEntry<dynamic>> menuItems = [];
    for (int i = 0; i < options.length; i++) {
      menuItems.add(
        PopupMenuItem(
          value: i,
          child: Text(
            '${options[i]} Tabloya Değiştir',
            style: TextStyle(
                fontSize: context.dynamicW(0.01) * context.dynamicH(0.0045)),
          ),
        ),
      );
    }
    return PopupMenuButton(
      iconColor: Colors.white,
      icon: Icon(icon),
      itemBuilder: (BuildContext context) {
        return menuItems;
      },
      onSelected: (index) {
        if (index == 0) {
          denemeProv.setIsTotal = false;
        } else {
          denemeProv.setIsTotal = true;
          denemeProv.setSelectedGroupSize = groupSizes[index];
          //denemeProv.initTable(denemeProv.getLessonName); later fix
        }
      },
    );
  }

  List<Widget> tab = LessonList.lessonNameList.map((tabName) {
    return Tab(
      text: tabName,
    );
  }).toList();

  SignButton buildBackUpButton(
      BuildContext context, DenemeViewModel denemeProv) {
    return SignButton(
        isGreyPng: true,
        onPressFunct: () async {
          String userId = AuthService().fAuth.currentUser!.uid;

          denemeProv.removeUserCollectionData(userId).then((value) {
            denemeProv.sendMultiplePostsToFirebase(userId).then((value) async {
              final table = await denemeProv.getTablesFromFirebase(userId);
              print(table.tableName);
            });
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        labelText: "Yedekle",
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: context.dynamicH(0.00571) * context.dynamicW(0.01),
        ));
  }
}
