// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_deneme_takip/core/constants/exam_subjects_data/kpss_subjects_data.dart';
import 'package:flutter_deneme_takip/core/local_database/exam_db_provider.dart';
import 'package:flutter_deneme_takip/models/exam.dart';
import 'package:flutter_deneme_takip/models/exam_detail.dart';
import 'package:flutter_deneme_takip/components/alert_dialog/alert_dialog.dart';
import 'package:intl/intl.dart';
import 'package:flutter_deneme_takip/core/constants/navigation_constants.dart';

enum EditexamState {
  empty,
  loading,
  completed,
  error,
}

class EditExamViewModel extends ChangeNotifier {
  // late NavigationService _navigation;
  final DateTime _now = DateTime.now();
  late EditexamState _state;

  late bool _isDiffZero;
  late bool _isNumberBig;
  late bool _isLoading;
  late bool _isAlertOpen;
  late bool _isKeyboardOpen;

  late String? _lessonName;
  late int? _lastexamId;
  late String _date;

  late List<String>? _subjectList;
  List<String?> _subjectSavedList = [];
  late List<TextEditingController> _falseCountControllers;
  late List<FocusNode> _listFocusNode;
  late int? _falseInputCount;
  List<int?> _falseCountsIntegers = [];
  late List<Map<String, dynamic>>? fakeData;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final formKey0 = GlobalKey<FormState>();

  EditExamViewModel() {
    _falseCountsIntegers.clear();
    _subjectSavedList.clear();

    //  _navigation = NavigationService.instance;
    _state = EditexamState.loading;
    _date =
        DateFormat('HH:mm:ss | d MMMM EEEE', 'tr_TR').format(_now).toString();

    _isLoading = true;
    _isDiffZero = false;
    _isNumberBig = false;
    _isAlertOpen = false;
    _isKeyboardOpen = false;

    _lessonName = 'Tarih';
    _subjectList = KpssSubjects.historySubjects;
    _falseInputCount = _subjectList!.length;
    _formKey = formKey0;
    fakeData = [];

    _lastexamId = 0;

    _falseCountsIntegers = List.generate(_falseInputCount!, (index) => 0);
    _subjectSavedList = List.of(findList(_lessonName!));
    _falseCountControllers = List.generate(_falseCountsIntegers.length,
        (index) => TextEditingController(text: '0'));
    _listFocusNode =
        List.generate(_falseCountsIntegers.length, (index) => FocusNode());
  }

  EditexamState get getState => _state;
  set setState(EditexamState state) {
    _state = state;
    notifyListeners();
  }

  void initFakeData() async {
    setState = EditexamState.loading;

    fakeData = [];

    await Future.delayed(const Duration(milliseconds: 350), () {
      setState = EditexamState.completed;
    });
  }

  List<String> findList(String lessonName) {
    return [];
    // return AppData.lessonListMap[lessonName] ?? [];
  }

  set setFormKey(GlobalKey<FormState> newKey) {
    _formKey = newKey;
  }

  GlobalKey<FormState> get getFormKey {
    return _formKey;
  }

  set setIsDiffZero(bool newBool) {
    _isDiffZero = newBool;
    notifyListeners();
  }

  bool get getIsDiffZero {
    return _isDiffZero;
  }

  set setIsNumberBig(bool newBool) {
    _isNumberBig = newBool;
    notifyListeners();
  }

  bool get getIsNumberBig {
    return _isNumberBig;
  }

  set setKeyboardVisibility(bool newBool) {
    _isKeyboardOpen = newBool;
    notifyListeners();
  }

  bool get getKeyboardVisibility {
    return _isKeyboardOpen;
  }

  set setLoading(bool newBool) {
    _isLoading = newBool;
    // notifyListeners();
  }

  bool get getIsLoading {
    return _isLoading;
  }

  set setSubjectList(List<String>? newSubjects) {
    //  _subjectList = newSubjects ?? AppData.subjectListNames['Tarih'];
  }

  List<String> get getSubjectList {
    return _subjectList ?? [];
  }

  set setFalseCountsIntegers(List<int?>? newFalseCount) {
    _falseCountsIntegers =
        newFalseCount ?? List.generate(_falseInputCount!, (index) => 0);
    notifyListeners();
  }

  List<int?>? get getFalseCountsIntegers {
    return _falseCountsIntegers;
  }

  set setFalseControllers(int controllerCount) {
    _falseCountControllers = List.generate(
        controllerCount, (index) => TextEditingController(text: "0"));

    notifyListeners();
  }

  List<TextEditingController> get getFalseControllers {
    return _falseCountControllers;
  }

  void setFocusNode() {
    _listFocusNode =
        List.generate(_falseCountsIntegers.length, (index) => FocusNode());

    notifyListeners();
  }

  List<FocusNode> get getFocusNode {
    return _listFocusNode;
  }

  int getFindexamId(List<int> existingIds, int latestId) {
    int lastId = 1;
    final int latest = latestId;
    List<int> existingId = existingIds;
    Set<int> existingIdSet = Set.from(existingId);

    for (int i = 1; i <= latest; i++) {
      if (!existingIdSet.contains(i)) {
        lastId = i;
        _lastexamId = lastId;
        return lastId;
      } else {
        lastId = (latest) + 1;
      }
    }
    return lastId;
  }

  Future<void> saveButton(
      {required bool isUpdate,
      int? updateExamId,
      int? cellId,
      String? lessonName,
      String? updateVal}) async {
    DateTime now = DateTime.now();
    // DateTime manualDate = DateTime(2024, 4, 14, 20, 23, 23);

    _date =
        DateFormat('HH:mm:ss | d MMMM EEEE', 'tr_TR').format(now).toString();

    _subjectSavedList = getSubjectList;
    //  List<int> existingIds =
//await ExamDbProvider.db.getAllexamIds(AppData.tableNames["Coğrafya"]!);
    //  int latestId = await ExamDbProvider.db
    //       .getFindLastId(AppData.tableNames["Coğrafya"]!, "examId") ??
    //    0;

    //printFunct("falseCounters", _falseCountsIntegers);
    //printFunct("subjectSavedList", _subjectSavedList);

    //  _lastexamId = getFindexamId(existingIds, latestId);
    if (isUpdate == false) {
      for (int i = 0; i < _falseCountsIntegers.length; i++) {
        /*  EditExamViewModel newEditModel = ExamDetailModel(
            subjectId: (i + 1),
            falseCount: _falseCountsIntegers[i],
            examDate: _date,
            subjectName: _subjectSavedList[i]);

        await saveExam(newEditModel); */
        setFalseControllers = getFalseControllers.length;
      }
    } else {
      //  _subjectSavedList = AppData.subjectListNames[lessonName ?? 'Tarih']!;

      ExamDetailModel updateexamModel = ExamDetailModel(
        examId: updateExamId,
        subjectId: cellId! + 1,
        // subjectName: _subjectSavedList[cellId],
        falseCount: int.parse(updateVal!),
//examDate: _date,
      );
      await updateExam(updateexamModel, lessonName ?? 'Tarih');
    }
  }

  Future<void> updateExam(ExamDetailModel exam, String lessonName) async {
    try {
      //   await ExamDbProvider.db.updateExam(exam, AppData.tableNames[lessonName]!);
    } catch (e) {
      printFunct("update exam error", e);
    }
    notifyListeners();
  }

  Future<void> saveExam(ExamModel exam, ExamDetailModel examDetail) async {
    try {
      await ExamDbProvider.db.insertExam(exam, examDetail);
    } catch (e) {
      printFunct("save exam error", e);
    }
    notifyListeners();
  }

  bool get getIsAlertOpen => _isAlertOpen;

  set setAlert(bool newBool) {
    _isAlertOpen = newBool;
  }

  Future<void> errorAlert(BuildContext context, String title, String content,
      EditExamViewModel editProv) async {
    AlertView alert = AlertView(
      title: title,
      content: content,
      isOneButton: true,
      noFunction: () => {
        editProv.setAlert = false,
        Navigator.of(context, rootNavigator: true)
            .pushNamed(NavigationConstants.homeView)
      },
      yesFunction: () => {
        editProv.setAlert = false,
        Navigator.of(context, rootNavigator: true)
            .pushNamed(NavigationConstants.homeView)
      },
    );
    if (editProv.getIsAlertOpen == false) {
      editProv.setAlert = true;
      await showDialog(
          barrierDismissible: false,
          barrierColor: const Color(0x66000000),
          context: context,
          builder: (BuildContext context) {
            return alert;
          }).then(
        (value) => editProv.setAlert = false,
      );
    }
  }

 

  void printFunct(String label, Object? data) {
    print("----------- $label --------------");
    print(data);
    print("----------- $label --------------");
  }

  Future<int?> getLastId(String table, String id) async {
    return await ExamDbProvider.db.getFindLastId(table, id);
  }
}
