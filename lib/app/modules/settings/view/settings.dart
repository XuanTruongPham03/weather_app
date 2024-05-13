import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rain/app/controller/controller.dart';
import 'package:rain/app/data/weather.dart';
import 'package:rain/app/modules/settings/widgets/setting_card.dart';
import 'package:rain/main.dart';
import 'package:rain/theme/theme_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final themeController = Get.put(ThemeController());
  final weatherController = Get.put(WeatherController());
  String? appVersion;
  String? colorBackground;
  String? colorText;

  Future<void> infoVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  void urlLauncher(String uri) async {
    final Uri url = Uri.parse(uri);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void initState() {
    infoVersion();
    super.initState();
  }

  updateLanguage(Locale locale) {
    settings.language = '$locale';
    isar.writeTxnSync(() => isar.settings.putSync(settings));
    Get.updateLocale(locale);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SettingCard(
            icon: const Icon(Iconsax.brush_1),
            text: 'appearance'.tr,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, setState) {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                'appearance'.tr,
                                style: context.textTheme.titleLarge?.copyWith(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SettingCard(
                              elevation: 4,
                              icon: const Icon(Iconsax.moon),
                              text: 'theme'.tr,
                              dropdown: true,
                              dropdownName: settings.theme?.tr,
                              dropdownList: <String>[
                                'system'.tr,
                                'dark'.tr,
                                'light'.tr
                              ],
                              dropdownCange: (String? newValue) {
                                final newThemeMode = newValue?.tr;
                                final darkTheme = 'dark'.tr;
                                final systemTheme = 'system'.tr;
                                ThemeMode themeMode =
                                    newThemeMode == systemTheme
                                        ? ThemeMode.system
                                        : newThemeMode == darkTheme
                                            ? ThemeMode.dark
                                            : ThemeMode.light;
                                String theme = newThemeMode == systemTheme
                                    ? 'system'
                                    : newThemeMode == darkTheme
                                        ? 'dark'
                                        : 'light';
                                themeController.saveTheme(theme);
                                themeController.changeThemeMode(themeMode);
                                setState(() {});
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          SettingCard(
            icon: const Icon(Iconsax.code),
            text: 'functions'.tr,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, setState) {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                'functions'.tr,
                                style: context.textTheme.titleLarge?.copyWith(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SettingCard(
                              elevation: 4,
                              icon: const Icon(Iconsax.map_1),
                              text: 'location'.tr,
                              switcher: true,
                              value: settings.location,
                              onChange: (value) async {
                                if (value) {
                                  bool serviceEnabled = await Geolocator
                                      .isLocationServiceEnabled();
                                  if (!serviceEnabled) {
                                    if (!context.mounted) return;
                                    await showAdaptiveDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog.adaptive(
                                          title: Text(
                                            'location'.tr,
                                            style: context.textTheme.titleLarge,
                                          ),
                                          content: Text('no_location'.tr,
                                              style: context
                                                  .textTheme.titleMedium),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Get.back(result: false),
                                              child: Text(
                                                'cancel'.tr,
                                                style: context
                                                    .textTheme.titleMedium
                                                    ?.copyWith(
                                                        color:
                                                            Colors.blueAccent),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Geolocator
                                                    .openLocationSettings();
                                                Get.back(result: true);
                                              },
                                              child: Text(
                                                'settings'.tr,
                                                style: context
                                                    .textTheme.titleMedium
                                                    ?.copyWith(
                                                        color: Colors.green),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    return;
                                  }
                                  weatherController.getCurrentLocation();
                                }
                                isar.writeTxnSync(() {
                                  settings.location = value;
                                  isar.settings.putSync(settings);
                                });
                                setState(() {});
                              },
                            ),
                            SettingCard(
                              elevation: 4,
                              icon: const Icon(Iconsax.notification_status),
                              text: 'timeRange'.tr,
                              dropdown: true,
                              dropdownName: '$timeRange',
                              dropdownList: const <String>[
                                '1',
                                '2',
                                '3',
                                '4',
                                '5',
                              ],
                              dropdownCange: (String? newValue) {
                                isar.writeTxnSync(() {
                                  settings.timeRange = int.parse(newValue!);
                                  isar.settings.putSync(settings);
                                });
                                MyApp.updateAppState(context,
                                    newTimeRange: int.parse(newValue!));
                                if (settings.notifications) {
                                  flutterLocalNotificationsPlugin.cancelAll();
                                  weatherController.notlification(
                                      weatherController.mainWeather);
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          SettingCard(
            icon: const Icon(Iconsax.d_square),
            text: 'data'.tr,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, setState) {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                'data'.tr,
                                style: context.textTheme.titleLarge?.copyWith(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SettingCard(
                              elevation: 4,
                              icon: const Icon(Iconsax.sun_1),
                              text: 'degrees'.tr,
                              dropdown: true,
                              dropdownName: settings.degrees.tr,
                              dropdownList: <String>[
                                'celsius'.tr,
                                'fahrenheit'.tr
                              ],
                              dropdownCange: (String? newValue) async {
                                isar.writeTxnSync(() {
                                  settings.degrees = newValue == 'celsius'.tr
                                      ? 'celsius'
                                      : 'fahrenheit';
                                  isar.settings.putSync(settings);
                                });
                                await weatherController.deleteAll(false);
                                await weatherController.setLocation();
                                await weatherController.updateCacheCard(true);
                                setState(() {});
                              },
                            ),
                            SettingCard(
                              elevation: 4,
                              icon: const Icon(Iconsax.clock),
                              text: 'timeformat'.tr,
                              dropdown: true,
                              dropdownName: settings.timeformat.tr,
                              dropdownList: <String>['12'.tr, '24'.tr],
                              dropdownCange: (String? newValue) {
                                isar.writeTxnSync(() {
                                  settings.timeformat =
                                      newValue == '12'.tr ? '12' : '24';
                                  isar.settings.putSync(settings);
                                });
                                setState(() {});
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          SettingCard(
            icon: const Icon(Iconsax.language_square),
            text: 'language'.tr,
            info: true,
            infoSettings: true,
            infoWidget: _TextInfo(
              info: appLanguages.firstWhere(
                  (element) => (element['locale'] == locale),
                  orElse: () => appLanguages.first)['name'],
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, setState) {
                      return ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              'language'.tr,
                              style: context.textTheme.titleLarge?.copyWith(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: appLanguages.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: ListTile(
                                  title: Text(
                                    appLanguages[index]['name'],
                                    style: context.textTheme.labelLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                  onTap: () {
                                    MyApp.updateAppState(context,
                                        newLocale: appLanguages[index]
                                            ['locale']);
                                    updateLanguage(
                                        appLanguages[index]['locale']);
                                  },
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
          SettingCard(
            icon: Image.asset(
              'assets/images/github.png',
              scale: 20,
            ),
            text: '${'project'.tr} GitHub',
            onPressed: () =>
                urlLauncher('https://github.com/XuanTruongPham03/weather_app'),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _TextInfo extends StatelessWidget {
  const _TextInfo({required this.info});

  final String info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Text(
        info,
        style: context.textTheme.bodyMedium,
        overflow: TextOverflow.visible,
      ),
    );
  }
}
