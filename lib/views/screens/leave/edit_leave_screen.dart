import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:widgets_easier/widgets_easier.dart';

import '../../../components/constants/colors.dart';
import '../../../components/constants/image_path.dart';
import '../../../components/constants/strings.dart';
import '../../../components/poviders/leave_provider/leave_provider.dart';
import '../../../components/poviders/leave_provider/leaves_provider.dart';
import '../../../components/styles/size_config.dart';
import '../../widgets/appbar/appbar_widget.dart';
import '../../widgets/bottom_sheet_push/bottom_sheet_push.dart';
import '../../widgets/text_input/custom_text_filed.dart';

class EditLeaveScreen extends ConsumerStatefulWidget {
  const EditLeaveScreen({super.key});

  @override
  ConsumerState createState() => _EditLeaveScreenState();
}

class _EditLeaveScreenState extends ConsumerState<EditLeaveScreen> {
  @override
  Widget build(BuildContext context) {
    final leaveProvider = ref.watch(stateLeaveProvider);
    final leaveNotifier = ref.read(leaveNotifierProvider.notifier);
    final leaveState = ref.watch(leaveNotifierProvider);

    // Future<void> showPickerDialog(
    //     BuildContext context, bool isSelectingStartTime, WidgetRef ref) async {
    //   final leaveNotifier = ref.read(leaveNotifierProvider.notifier);
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return DatePickerDialogWidget(
    //         selectedDate: DateTime.now(),
    //         onDateSelected: (newDate) {
    //           if (isSelectingStartTime) {
    //             leaveNotifier.startDateController.text =
    //                 DateFormat('dd-MM-yyyy').format(newDate);
    //           } else {
    //             leaveNotifier.endDateController.text =
    //                 DateFormat('dd-MM-yyyy').format(newDate);
    //           }
    //           print('Selected Date: $newDate');
    //         },
    //       );
    //     },
    //   );
    // }

    Future<void> buildShowImageModalBottomSheet(
        BuildContext context, WidgetRef ref) {
      return showModalBottomSheet(
        backgroundColor: const Color(0xFfF8F9FC),
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return ImagePickerBottomSheet(
            onCameraTap: () async {
              await ref.read(stateLeaveProvider).pickImageFromCamera();
              print('Camera tapped');
            },
            onGalleryTap: () async {
              await ref.read(stateLeaveProvider).pickImageFromCamera();
              print('Gallery tapped');
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kTextWhiteColor),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: AppbarWidget(),
        title: const Text(Strings.txtEditLeave),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Strings.txtLeaveStart,
                            style: GoogleFonts.notoSansLao(
                              textStyle: Theme.of(context).textTheme.titleLarge,
                              fontSize: SizeConfig.textMultiplier * 1.9,
                            ),
                          ),
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              // showPickerDialog(context, true, ref).then((_) {
                              //   if (leaveNotifier
                              //       .conditionController.text.isEmpty) {
                              //     return null;
                              //   }
                              // });
                            },
                            child: AbsorbPointer(
                              child: CustomTextField(
                                hintText: Strings.txtSelectDate,
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: kRedColor, width: 0.5),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: kGary, width: 1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                prefixIcon: Image.asset(ImagePath.iconCalendar),
                                suffixIcon: const Icon(
                                  Icons.arrow_right,
                                ),
                                // controller: leaveNotifier.startDateController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Strings.txtLeaveStart.tr,
                            style: GoogleFonts.notoSansLao(
                              textStyle: Theme.of(context).textTheme.titleLarge,
                              fontSize: SizeConfig.textMultiplier * 1.9,
                            ),
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              // showPickerDialog(context, true, ref).then((_) {
                              //   if (leaveNotifier
                              //       .conditionController.text.isEmpty) {
                              //     return null;
                              //   }
                              // });
                            },
                            child: AbsorbPointer(
                              child: CustomTextField(
                                hintText: Strings.txtSelectDate,
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: kRedColor, width: 0.5),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: kGary, width: 1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                prefixIcon: Image.asset(ImagePath.iconCalendar),
                                suffixIcon: const Icon(
                                  Icons.arrow_right,
                                ),
                                // controller: leaveNotifier.startDateController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Strings.txtAssignTemporaryWork,
                        style: GoogleFonts.notoSansLao(
                          textStyle: Theme.of(context).textTheme.titleLarge,
                          fontSize: SizeConfig.textMultiplier * 1.9,
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomTextField(
                      hintText: Strings.txtAssignTemporaryWork,
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: kRedColor, width: 0.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: kGary, width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      prefixIcon: Image.asset(ImagePath.iconMember),
                      controller: leaveNotifier.assignWorkController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(Strings.txtDescriptionTaskList,
                        style: GoogleFonts.notoSansLao(
                          textStyle: Theme.of(context).textTheme.titleLarge,
                          fontSize: SizeConfig.textMultiplier * 1.9,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      maxLines: 6,
                      hintText: Strings.txtPLeaseEnter,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFFFCE6E4), width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      prefixIcon: null,
                      controller: leaveNotifier.descriptionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(Strings.txtNote,
                        style: GoogleFonts.notoSansLao(
                          textStyle: Theme.of(context).textTheme.titleLarge,
                          fontSize: SizeConfig.textMultiplier * 1.9,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      maxLines: 4,
                      hintText: Strings.txtPLeaseEnter,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: kGary, width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      prefixIcon: null,
                      controller: leaveNotifier.noteController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.txtReason,
                      style: GoogleFonts.notoSansLao(
                        textStyle: Theme.of(context).textTheme.titleLarge,
                        fontSize: SizeConfig.textMultiplier * 1.9,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      maxLines: 2,
                      hintText: Strings.txtPLeaseEnter,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: kGary, width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      prefixIcon: null,
                      controller: leaveNotifier.reasonController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.txtGoHospital,
                      style: GoogleFonts.notoSansLao(
                        textStyle: Theme.of(context).textTheme.titleLarge,
                        fontSize: SizeConfig.textMultiplier * 1.9,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: SizeConfig.heightMultiplier * 5.7,
                            decoration: BoxDecoration(
                                color: kTextWhiteColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: RadioListTile<String>(
                              title: Text('Yes',
                                  style: GoogleFonts.notoSansLao(
                                    textStyle:
                                        Theme.of(context).textTheme.titleLarge,
                                    fontSize: SizeConfig.textMultiplier * 1.9,
                                  )),
                              value: 'Yes',
                              groupValue: leaveProvider.selectedRadioOption,
                              onChanged: (value) {
                                ref
                                    .read(stateLeaveProvider)
                                    .setSelectedRadioOption(value!);
                              },
                              activeColor: kBlueColor,
                              secondary:
                                  leaveProvider.selectedRadioOption == "Yes"
                                      ? Icon(Icons.check, color: kBlueColor)
                                      : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: SizeConfig.heightMultiplier * 5.7,
                            decoration: BoxDecoration(
                                color: kTextWhiteColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: RadioListTile<String>(
                              title: Text(Strings.txtNo,
                                  style: GoogleFonts.notoSansLao(
                                    textStyle:
                                        Theme.of(context).textTheme.titleLarge,
                                    fontSize: SizeConfig.textMultiplier * 1.9,
                                  )),
                              value: 'No',
                              groupValue: leaveProvider.selectedRadioOption,
                              onChanged: (value) {
                                ref
                                    .read(stateLeaveProvider)
                                    .setSelectedRadioOption(value!);
                              },
                              activeColor: kBlueColor,
                              secondary:
                                  leaveProvider.selectedRadioOption == "No"
                                      ? Icon(Icons.check, color: kBlueColor)
                                      : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(Strings.txtStartTime,
                            style: GoogleFonts.notoSansLao(
                              textStyle: Theme.of(context).textTheme.titleLarge,
                              fontSize: SizeConfig.textMultiplier * 1.9,
                            )),
                        CustomTextField(
                          hintText: Strings.txtPLeaseEnter,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: kGary, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: null,
                          controller: leaveNotifier.conditionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        Text(
                          Strings.txtAccordingTo,
                          style: GoogleFonts.notoSansLao(
                            textStyle: Theme.of(context).textTheme.titleLarge,
                            fontSize: SizeConfig.textMultiplier * 1.9,
                          ),
                        ),
                        CustomTextField(
                          hintText: Strings.txtPLeaseEnter,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: kGary, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: null,
                          controller: leaveNotifier.accordingController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          Strings.txtPlace,
                          style: GoogleFonts.notoSansLao(
                            textStyle: Theme.of(context).textTheme.titleLarge,
                            fontSize: SizeConfig.textMultiplier * 1.9,
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          hintText: Strings.txtPLeaseEnter,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: kGary, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: null,
                          controller: leaveNotifier.placeController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          Strings.txtPhone,
                          style: GoogleFonts.notoSansLao(
                            textStyle: Theme.of(context).textTheme.titleLarge,
                            fontSize: SizeConfig.textMultiplier * 1.9,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          hintText: Strings.txtPLeaseEnter,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: kGary, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: null,
                          controller: leaveNotifier.phoneController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          Strings.txtSolution,
                          style: GoogleFonts.notoSansLao(
                            textStyle: Theme.of(context).textTheme.titleLarge,
                            fontSize: SizeConfig.textMultiplier * 1.9,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          hintText: Strings.txtPLeaseEnter,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: kGary, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: null,
                          controller: leaveNotifier.solutionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(Strings.txtUploadImage,
                            style: GoogleFonts.notoSansLao(
                              textStyle: Theme.of(context).textTheme.titleLarge,
                              fontSize: SizeConfig.textMultiplier * 1.9,
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            buildShowImageModalBottomSheet(context, ref);
                          },
                          child: Container(
                              height: SizeConfig.heightMultiplier * 16,
                              width: SizeConfig.widthMultiplier * 100,
                              decoration: ShapeDecoration(
                                shape: DashedBorder(
                                  color: kGreyColor2,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: leaveProvider.selectedImage == null
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(Strings.txtUploadImage,
                                              style: GoogleFonts.notoSansLao(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                                fontSize:
                                                    SizeConfig.textMultiplier *
                                                        1.9,
                                              )),
                                          const SizedBox(width: 30),
                                          SizedBox(
                                            child: Image.asset(
                                              ImagePath.iconIconImage,
                                              width:
                                                  SizeConfig.widthMultiplier *
                                                      6,
                                              height:
                                                  SizeConfig.heightMultiplier *
                                                      6,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.file(
                                            File(leaveProvider
                                                .selectedImage!.path),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          )))),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: leaveState.isValid
                          ? () {
                              if (leaveNotifier.formKey.currentState!
                                  .validate()) {}
                            }
                          : null,
                      child: Container(
                        height: SizeConfig.heightMultiplier * 7,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: leaveState.isValid ? kYellowFirstColor : kGary,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            Strings.txtSubmitForm,
                            style: GoogleFonts.notoSansLao(
                              textStyle: Theme.of(context).textTheme.titleLarge,
                              fontSize: SizeConfig.textMultiplier * 2.5,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
