import 'package:flutter/material.dart';
import 'package:flutter_deneme_takip/core/constants/lesson_list.dart';
import 'package:flutter_deneme_takip/core/extensions/context_extensions.dart';
import 'package:flutter_deneme_takip/core/navigation/navigation_service.dart';
import 'package:flutter_deneme_takip/core/notifier/bottom_navigation_notifier.dart';
import 'package:flutter_deneme_takip/core/notifier/tabbar_navigation_notifier.dart';
import 'package:flutter_deneme_takip/view/tabbar_views/deneme_edit_tabbar.dart';
import 'package:flutter_deneme_takip/view/tabbar_views/deneme_tabbar_view.dart';
import 'package:flutter_deneme_takip/view/tabbar_views/lesson_tabbar_view.dart';
import 'package:flutter_deneme_takip/view_model/deneme_view_model.dart';
import 'package:flutter_deneme_takip/view_model/edit_deneme_view_model.dart';
import 'package:flutter_deneme_takip/view_model/lesson_view_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class BottomTabbarView extends StatefulWidget {
  const BottomTabbarView({super.key});

  @override
  State<BottomTabbarView> createState() => _BottomTabbarViewState();
}

final NavigationService navigation = NavigationService.instance;

class _BottomTabbarViewState extends State<BottomTabbarView> {
  @override
  void initState() {
    super.initState();
  }

  static List<Widget> currentScreen = const [
    LessonTabbarView(),
    DenemeTabbarView(),
    DenemeEditTabbarView(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BottomNavigationProvider>(context);
    final tabbarNavProv = Provider.of<TabbarNavigationProvider>(context);

    final lessonProv = Provider.of<LessonViewModel>(context);
    final denemeProv = Provider.of<DenemeViewModel>(context);
    final editProv = Provider.of<EditDenemeViewModel>(context);
    return Scaffold(
      body: currentScreen[provider.getCurrentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff1c0f45),
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.greenAccent,
        selectedFontSize: context.dynamicW(0.01) * context.dynamicH(0.005),
        unselectedFontSize: context.dynamicW(0.01) * context.dynamicH(0.005),
        currentIndex: provider.getCurrentIndex,
        onTap: (index) {
          provider.setCurrentIndex = index;
          denemeProv.setLessonName =
              LessonList.lessonNameList[tabbarNavProv.getCurrentDenemeIndex];
          denemeProv.initData(
              LessonList.lessonNameList[tabbarNavProv.getCurrentDenemeIndex]);

          lessonProv.setLessonName =
              LessonList.lessonNameList[tabbarNavProv.getLessonCurrentIndex];
          lessonProv.initLessonData(
              LessonList.lessonNameList[tabbarNavProv.getLessonCurrentIndex]);

          editProv.setFalseControllers =
              editProv.getFalseCountsIntegers!.length;

          editProv.setLoading = true;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.house,
            ),
            label: "Dersler",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.house,
            ),
            label: "Denemeler",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.house,
            ),
            label: "DenemeGir",
          ),
        ],
      ),
    );
  }
}
