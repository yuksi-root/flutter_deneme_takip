// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_deneme_takip/components/app_bar/custom_app_bar.dart';
import 'package:flutter_deneme_takip/core/constants/app_data.dart';
import 'package:flutter_deneme_takip/core/constants/app_theme.dart';
import 'package:flutter_deneme_takip/core/constants/color_constants.dart';
import 'package:flutter_deneme_takip/core/extensions/context_extensions.dart';
import 'package:flutter_deneme_takip/core/notifier/tabbar_navigation_notifier.dart';
import 'package:flutter_deneme_takip/view/bottom_tabbar_views/deneme_view.dart';
import 'package:flutter_deneme_takip/view/navbar_view/navigation_drawer.dart';
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
      length: AppData.lessonNameList.length,
      initialIndex: tabbarNavProv.getCurrentDenemeIndex,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() async {
          if (!tabController.indexIsChanging) {
            tabbarNavProv.setCurrentDenemeIndex = tabController.index;
            print(
                "fontSize ${AppTheme.dynamicSize(dynamicHSize: 0.0045, dynamicWSize: 0.0085)}");
            print(
                "height ${AppTheme.dynamicSize(dynamicHSize: 0.0117, dynamicWSize: 0.032)}");
            print(
                "width ${AppTheme.dynamicSize(dynamicHSize: 0.014, dynamicWSize: 0.02)}");

            denemeProv.setLessonName =
                AppData.lessonNameList[tabbarNavProv.getCurrentDenemeIndex];

            denemeProv.initDenemeData(
                AppData.lessonNameList[tabbarNavProv.getCurrentDenemeIndex]);

            denemeProv.setInitPng = AppData.lessonPngList[
                AppData.lessonNameList[tabbarNavProv.getCurrentDenemeIndex]];

            denemeProv.listContHeights.clear();
          }
        });
        return Scaffold(
          drawer: const NavDrawer(),
          appBar: buildAppBar(denemeProv, context),
          body: TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              AppData.lessonNameList.length,
              (index) {
                return const DenemeView();
              },
            ),
          ),
        );
      }),
    );
  }

  CustomAppBar buildAppBar(DenemeViewModel denemeProv, BuildContext context) {
    return CustomAppBar(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          actions: <Widget>[
            buildPopupMenu(Icons.more_vert_sharp, denemeProv),
          ],
          title: const Center(
              child: Text(textAlign: TextAlign.center, 'Deneme App')),
          bottom: TabBar(
              isScrollable: true, tabAlignment: TabAlignment.start, tabs: tab),
        ),
        dynamicPreferredSize: context.dynamicH(0.15),
        gradients: ColorConstants.appBarGradient);
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
        }
      },
    );
  }

  List<Widget> tab = AppData.lessonNameList.map((tabName) {
    return Tab(
      text: tabName,
    );
  }).toList();
}
