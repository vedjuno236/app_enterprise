import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/key_shared.dart';
import 'package:enterprise/components/helpers/shared_prefs.dart';
import 'package:enterprise/components/logger/logger.dart';
import 'package:enterprise/components/poviders/leave_provider/leave_teamhighlights_provider/leave_teamhigh_provider.dart';
import 'package:enterprise/components/poviders/notifition_provider/notifition_provider.dart';
import 'package:enterprise/components/router/router.dart';
import 'package:enterprise/components/services/api_service/enterprise_service.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../components/constants/strings.dart';

class TeamHighlightsWidget extends ConsumerStatefulWidget {
  const TeamHighlightsWidget({super.key});

  @override
  ConsumerState createState() => _ComingEventsWidgetState();
}

class _ComingEventsWidgetState extends ConsumerState<TeamHighlightsWidget> {
  bool isLoading = false;
  SharedPrefs sharedPrefs = SharedPrefs();

  Future fetchNotificationApi() async {
    DateTime now = DateTime.now();
    String formattedNow = DateFormat('yyyy-MM-dd').format(now);
    setState(() {
      isLoading = true;
    });
    EnterpriseAPIService()
        .callNotification(
          token: sharedPrefs.getStringNow(KeyShared.keyToken),
          start_date: formattedNow,
          end_date: formattedNow,
        )
        .then((value) {
          ref.watch(teamHighlightsProvider).setNotificationModel(value: value);
        })
        .catchError((onError) {})
        .whenComplete(() => setState(() {
              isLoading = false;
            }));
  }

  @override
  void initState() {
    super.initState();
    fetchNotificationApi();
  }

  @override
  Widget build(BuildContext context) {
    final notiProvider = ref.watch(teamHighlightsProvider);
    final notificationData = notiProvider.getNotificationModel?.data ?? [];
    return Container(
      width: double.infinity,
      height: SizeConfig.heightMultiplier * 20,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).cardColor,
            blurRadius: 1.0,
            spreadRadius: 1.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: const BoxDecoration(
                    color: kYellowFirstColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          notificationData.length.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontSize: SizeConfig.textMultiplier * 3),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: SizeConfig.widthMultiplier * 4),
                Expanded(
                  child: Text(
                    Strings.txtPeoplefrom.tr,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
            const Divider(
              color: Color(0xFFF3F3F3),
              thickness: 1.0,
              height: 20.0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0;
                            i <
                                (notificationData.length > 3
                                    ? 3
                                    : notificationData.length);
                            i++)
                          Align(
                            widthFactor: 0.6,
                            child: CircleAvatar(
                              radius: SizeConfig.heightMultiplier * 2.6,
                              backgroundColor: kTextWhiteColor,
                              child: CircleAvatar(
                                radius: SizeConfig.heightMultiplier * 2,
                                backgroundImage: NetworkImage(notificationData[
                                        i]
                                    .profile
                                    .toString()), // Access the correct property
                              ),
                            ),
                          ),
                        if (notificationData.length > 3)
                          Align(
                            widthFactor: 0.6,
                            child: CircleAvatar(
                                radius: SizeConfig.heightMultiplier * 2,
                                backgroundColor: kYellowColor,
                                child: Text(
                                  '+${(notificationData.length - 3).toString()}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontSize:
                                              SizeConfig.textMultiplier * 1.9,
                                          color: kTextWhiteColor),
                                )),
                          ),
                      ],
                    ),
                    TextButton(
                        onPressed: () {
                          context.push(PageName.onLeaveRoute);
                        },
                        child: Row(
                          children: [
                            Text(
                              Strings.txtSeeAll.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 1.9,
                                  ),
                            ),
                            Icon(
                              Icons.arrow_right,
                            )
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
