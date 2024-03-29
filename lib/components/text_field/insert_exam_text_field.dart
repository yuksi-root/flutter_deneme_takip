// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_deneme_takip/core/extensions/context_extensions.dart';
import 'package:flutter_deneme_takip/view_model/exam_table_view_model.dart';
import 'package:flutter_deneme_takip/view_model/edit_exam_view_model.dart';
import 'package:provider/provider.dart';

class InsertExamTextField extends StatelessWidget {
  const InsertExamTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final EditExamViewModel editProv =
        Provider.of<EditExamViewModel>(context, listen: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 1; i < editProv.getFalseCountsIntegers!.length; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: editProv.getFalseControllers[i],
                      focusNode: editProv.getFocusNode[i],
                      canRequestFocus: true,
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      onTap: () {
                        var focusNode = editProv.getFocusNode[i];
                        void onFocusChange() {
                          if (focusNode.hasFocus) {
                            editProv.setKeyboardVisibility = true;
                            editProv.getFalseControllers[i].clear();
                          } else {
                            editProv.setKeyboardVisibility = false;
                            focusNode.removeListener(onFocusChange);
                          }
                        }

                        focusNode.addListener(onFocusChange);
                      },
                      onTapOutside: (event) {
                        context
                            .read<EditExamViewModel>()
                            .setKeyboardVisibility = false;
                        FocusScope.of(context).unfocus();
                      },
                      onEditingComplete: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Future.delayed(const Duration(milliseconds: 2), () {
                            if (WidgetsBinding.instance.platformDispatcher.views
                                    .last.viewInsets.bottom ==
                                0) {
                              context
                                  .read<EditExamViewModel>()
                                  .setKeyboardVisibility = false;
                            } else {
                              context
                                  .read<EditExamViewModel>()
                                  .setKeyboardVisibility = true;
                            }
                          });

                          if (i < editProv.getFalseCountsIntegers!.length - 1) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              FocusScope.of(context)
                                  .requestFocus(editProv.getFocusNode[i + 1]);
                              editProv.getFalseControllers[i + 1].clear();
                            });
                          } else {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              FocusScope.of(context)
                                  .requestFocus(editProv.getFocusNode[1]);
                              editProv.getFalseControllers[1].clear();
                            });
                          }
                        });
                      },
                      style: TextStyle(
                          color: Colors.black,
                          fontSize:
                              context.dynamicW(0.01) * context.dynamicH(0.004)),
                      validator: (value) {
                        try {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen boş bırakmayın';
                          }
                          final isNumeric =
                              RegExp(r'^-?[0-9]+$').hasMatch(value);
                          if (!isNumeric) {
                            Future.delayed(
                              const Duration(milliseconds: 0),
                              () {
                                editProv.getFormKey.currentState!.reset();
                              },
                            );
                          } else if (int.parse(value) > 99) {
                            editProv.getFalseControllers[i].clear();

                            return "Yanlış sayısı 99'dan büyük olamaz!";
                          } else {
                            return null;
                          }

                          return "Sadece Sayı Giriniz";
                        } catch (e) {
                          print(e);
                        }
                        return null;
                      },
                      onChanged: (value) {
                        try {
                          if (int.parse(value) != 0) {
                            editProv.setIsDiffZero = true;
                          } else if (int.parse(value) > 99) {
                            editProv.getFalseControllers[i].clear();
                          } else {
                            editProv.setIsDiffZero = false;
                          }

                          editProv.getFalseCountsIntegers![i] =
                              int.parse(value);
                        } catch (e) {
                          print(e);
                          ExamTableViewModel().printFunct("onChanged catch", e);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Konu Yanlış Sayısı",
                        label: Text(
                          editProv.getSubjectList[i],
                          style: TextStyle(
                              fontSize: context.dynamicW(0.01) *
                                  context.dynamicH(0.005)),
                        ),
                        icon: buildContaierIconField(
                            context, Icons.assignment_rounded),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: context.dynamicH(0.0428),
              ),
            ],
          ),
      ],
    );
  }

  Container buildContaierIconField(BuildContext context, IconData icon) {
    return Container(
      height: context.dynamicW(0.05),
      width: context.dynamicW(0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
      ),
    );
  }
}
