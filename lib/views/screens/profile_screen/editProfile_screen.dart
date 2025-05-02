import 'package:enterprise/components/poviders/profiled_provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/constants/colors.dart';
import '../../../components/constants/strings.dart';
import '../../../components/styles/size_config.dart';
import '../../widgets/appbar/appbar_widget.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _statusController;
  late TextEditingController _skillsController;
  final int maxLengthStatus = 100;
  final int maxLengthSkills = 15;

  @override
  void initState() {
    super.initState();
    _statusController = TextEditingController();
    _statusController.addListener(() => _onTextChanged(ref));

    _skillsController = TextEditingController();
    _skillsController.addListener(() => _onTextChangedSkill(ref));
  }

  void _onTextChanged(WidgetRef ref) {
    final text = _statusController.text;

    if (text.length > maxLengthStatus) {
      _statusController.text = text.substring(0, maxLengthStatus);
      _statusController.selection = TextSelection.fromPosition(
        TextPosition(offset: _statusController.text.length),
      );
    }

    ref.read(stateProfileProvider).updateTxtStatus(_statusController.text);
  }

  void _onTextChangedSkill(WidgetRef ref) {
    final text = _skillsController.text;

    if (text.length > maxLengthSkills) {
      _skillsController.text = text.substring(0, maxLengthSkills);
      _skillsController.selection = TextSelection.fromPosition(
        TextPosition(offset: _skillsController.text.length),
      );
    }

    ref.read(stateProfileProvider).updateTxtSkills(_skillsController.text);
  }

  @override
  void dispose() {
    _statusController.removeListener(() => _onTextChanged(ref));
    _statusController.dispose();
    _skillsController.removeListener(() => _onTextChangedSkill(ref));
    _skillsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> skillsData = [
      {
        'name': '’90s kid',
      },
      {
        'name': 'Designing',
      },
      {
        'name': 'Religion',
      },
      {
        'name': 'Cooking',
      },
      {
        'name': 'Self-Care',
      },
      {
        'name': 'Food & drink ',
      },
      {
        'name': 'Running',
      },
      {
        'name': 'Sport ',
      }
    ];

    final profileProvider = ref.watch(stateProfileProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: const AppbarWidget(),
        title: const Text(Strings.txtEditProfile),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: SizeConfig.textMultiplier * 1.6),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kTextWhiteColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  color: kTextWhiteColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextField(
                        controller: _statusController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Respects and positive energy',
                          border: InputBorder.none,
                        ),
                      ),
                      const Divider(color: kGary),
                      Text(
                          '${profileProvider.charCountStatus}/$maxLengthStatus'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Passion & Skills',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: SizeConfig.textMultiplier * 1.6),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: skillsData.map((skill) {
                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: kTextWhiteColor,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: kYellowFirstColor,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 5),
                        Text(
                          skill['name'],
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontSize: SizeConfig.textMultiplier * 1.6),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  buildShowModalBottomSheet(
                    context: context,
                    maxLengthSkills: maxLengthSkills,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: kYellowFirstColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 5),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: kBack87,
                            radius: SizeConfig.heightMultiplier * 1.6,
                            child:
                                const Icon(Icons.add, color: kYellowFirstColor),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Add more passion',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 1.6),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 25),
              Container(
                height: SizeConfig.heightMultiplier * 6,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: kYellowFirstColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    'Confirm editing',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: SizeConfig.textMultiplier * 1.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet({
    required BuildContext context,
    required int maxLengthSkills,
  }) {
    return showModalBottomSheet(
      backgroundColor: kTextWhiteColor,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Consumer(
          builder: (context, ref, child) {
            final charCountSkills =
                ref.watch(stateProfileProvider).charCountSkills;

            return FractionallySizedBox(
              heightFactor: 0.6,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Add more passion & Skills',
                              style: GoogleFonts.notoSansLao(
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontSize: SizeConfig.textMultiplier * 2,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFFCE6E4),
                                  width: 1, // Set the border width
                                ),
                                borderRadius: BorderRadius.circular(15),
                                color: const Color(0xFFFFFFFF)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  TextField(
                                    controller: _skillsController,
                                    decoration: const InputDecoration(
                                      hintText: 'Add more passion & Skills',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                  const Divider(
                                    color: kGary,
                                  ),
                                  Text(
                                    '$charCountSkills/$maxLengthSkills',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            height: SizeConfig.heightMultiplier * 6,
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: kYellowFirstColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text(
                                'Add to my passion',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontSize: SizeConfig.textMultiplier * 1.6,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
