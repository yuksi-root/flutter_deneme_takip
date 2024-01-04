import 'package:flutter/material.dart';
import 'package:flutter_deneme_takip/components/insert_widgets/insert_deneme_button.dart';
import 'package:flutter_deneme_takip/view_model/edit_deneme_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_deneme_takip/core/extensions/context_extensions.dart';
import 'package:flutter_deneme_takip/components/custom_app_bar.dart';

class FadedForm extends StatefulWidget {
  const FadedForm({Key? key}) : super(key: key);

  @override
  _FadedFormState createState() => _FadedFormState();
}

class _FadedFormState extends State<FadedForm>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _fadedColor;
  late Animation<Gradient?> _fadedGradient;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _fadedGradient = LinearGradientTween(
      begin: const LinearGradient(
        colors: [
          Color(0xFF00bfff),
          Color(0xFFbdc3c7),
        ],
        stops: [0.0, 1.0],
      ),
      end: LinearGradient(
        colors: [
          Color(0xFF00bfff).withOpacity(0.5),
          Color(0xFFbdc3c7).withOpacity(0.5),
        ],
        stops: [0.0, 1.0],
      ),
    ).animate(_controller);

    _fadedColor =
        ColorTween(begin: Colors.black, end: Colors.grey.withOpacity(0.3))
            .animate(_controller);

    _startFading();
  }

  void _startFading() {
    _controller.forward();
  }

  Animation<Color?> _fadedWidgetColor(Color widgetColor) {
    _fadedColor =
        ColorTween(begin: widgetColor, end: Colors.grey.withOpacity(0.3))
            .animate(_controller);
    return _fadedColor;
  }

  @override
  Widget build(BuildContext context) {
    final EditDenemeViewModel editProv =
        Provider.of<EditDenemeViewModel>(context, listen: true);
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  fadedAppBarWidget(editProv, context),
                  for (int i = 1; i < 11; i++)
                    fadedInputFormWidget(editProv, i, context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Column fadedInputFormWidget(
      EditDenemeViewModel editProv, int i, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextFormField(
                controller: editProv.getFalseControllers[i],
                style: TextStyle(
                  color: _fadedWidgetColor(Colors.black).value!,
                  fontSize: MediaQuery.of(context).size.width * 0.02,
                ),
                decoration: InputDecoration(
                  hintText: "Konu Yanlış Sayısı",
                  label: Text(
                    editProv.getSubjectList[i],
                    style: TextStyle(
                        color: _fadedWidgetColor(Colors.black).value!,
                        fontSize:
                            context.dynamicW(0.01) * context.dynamicH(0.005)),
                  ),
                  icon: buildContaierIconField(
                      context, Icons.assignment_rounded,
                      iconColor: _fadedWidgetColor(Colors.purple).value!),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.0428,
        ),
      ],
    );
  }

  Container fadedAppBarWidget(
      EditDenemeViewModel editProv, BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: _fadedGradient.value!),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceEvenly,
        spacing: 10,
        children: [
          Text(
            '${editProv.getLessonName} Dersi Girişi',
            style: TextStyle(
                color: _fadedWidgetColor(Colors.white).value!,
                fontSize: context.dynamicW(0.01) * context.dynamicH(0.005)),
          ),
          SizedBox(
              height: context.dynamicH(0.0571),
              child: fadedSaveButton(context)),
        ],
      ),
    );
  }

  ElevatedButton fadedSaveButton(BuildContext context) {
    return ElevatedButton.icon(
        icon: Icon(color: _fadedWidgetColor(Colors.green).value!, Icons.save),
        label: Text(" Kaydet ",
            style: TextStyle(
                color: _fadedWidgetColor(Colors.white).value!,
                fontSize: context.dynamicH(0.00571) * context.dynamicW(0.01))),
        onPressed: () async {},
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _fadedWidgetColor(Theme.of(context).primaryColor).value!,
          shape: const StadiumBorder(),
          foregroundColor: Colors.black,
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Container buildContaierIconField(BuildContext context, IconData icon,
      {Color? iconColor}) {
    return Container(
      height: context.dynamicW(0.05),
      width: context.dynamicW(0.05),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(context.dynamicW(0.0025)),
      child: Icon(icon, color: iconColor),
    );
  }
}

class LinearGradientTween extends Tween<LinearGradient?> {
  LinearGradientTween({LinearGradient? begin, LinearGradient? end})
      : super(begin: begin, end: end);

  @override
  LinearGradient? lerp(double t) {
    return LinearGradient.lerp(begin, end, t);
  }
}
