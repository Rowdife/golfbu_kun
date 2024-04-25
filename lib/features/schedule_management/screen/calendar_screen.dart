import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/schedule_management/models/calendar_event_model.dart';
import 'package:golfbu_kun/features/schedule_management/repos/calendar_repo.dart';
import 'package:golfbu_kun/features/schedule_management/widgets/schedule_upload_widget.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  String _uid = "";
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  final DateTime _today = DateTime.now();
  List<CalendarEventModel> _selectedEventsList = [];
  List<CalendarEventModel> _todayEventsList = [];
  List<CalendarEventModel> _allEventsList = [];

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  void _getSelectedDaySchedule(DateTime date) async {
    final focusedDateSchedule = await ref
        .read(calendarRepo)
        .getScheduleListByDate(date.toString().substring(0, 10));

    // Convert Instance of CalendarEventModel to JSON
    final jsonList =
        focusedDateSchedule.map((event) => event.toJson()).toList();
    if (jsonList.isNotEmpty) {
      setState(() {
        _selectedEventsList =
            jsonList.map((json) => CalendarEventModel.fromJson(json)).toList();
      });
    } else {
      setState(() {
        _selectedEventsList = [];
      });
    }
  }

  void _deleteSchedule(int createdAt) async {
    await ref.read(calendarRepo).deleteSchedule(createdAt);
    _getTodaySchedule();
    _getSelectedDaySchedule(_focusedDay);
    _getAllSchedule();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                "スケジュールを削除しました",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.grey.shade900,
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.greenAccent),
                  ),
                ),
              ],
            ));
  }

  void _getTodaySchedule() async {
    final todaySchedule = await ref
        .read(calendarRepo)
        .getScheduleListByDate(_today.toString().substring(0, 10));
    final jsonList = todaySchedule.map((event) => event.toJson()).toList();
    if (jsonList.isNotEmpty) {
      setState(() {
        _todayEventsList =
            jsonList.map((json) => CalendarEventModel.fromJson(json)).toList();
      });
    } else {
      setState(() {
        _todayEventsList = [];
      });
    }
  }

  _getAllSchedule() async {
    final allSchedule = await ref.read(calendarRepo).getAllSchedule();
    final jsonList = allSchedule.map((event) => event.toJson()).toList();
    if (jsonList.isNotEmpty) {
      setState(() {
        _allEventsList =
            jsonList.map((json) => CalendarEventModel.fromJson(json)).toList();
      });
    } else {
      setState(() {
        _allEventsList = [];
      });
    }
  }

  Future<void> _onRefresh() async {
    _getTodaySchedule();
    await _getAllSchedule();
  }

  void _uploadScheduleTap(DateTime date, TimeOfDay time) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      scrollControlDisabledMaxHeightRatio: 0.5,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: ScheduleUploadForm(
            date: date,
            time: time,
          ),
        );
      },
    );
    _onRefresh();
  }

  @override
  void initState() {
    super.initState();
    _onRefresh();
    _uid = ref.read(authRepo).user!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            onPressed: _onRefresh,
            icon: const FaIcon(FontAwesomeIcons.arrowsRotate),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2030),
            builder: (BuildContext context, Widget? child) => Theme(
              data: ThemeData(
                splashFactory: NoSplash.splashFactory,
                appBarTheme: Theme.of(context).appBarTheme.copyWith(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.white),
                scaffoldBackgroundColor: Colors.grey.shade900,
                colorScheme: ColorScheme.fromSwatch().copyWith(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                  secondary: Colors.white,
                  secondaryContainer: const Color.fromARGB(255, 45, 66, 46),
                  onSurface: Colors.white,
                  background: Colors.white,
                  primaryContainer: Colors.white,
                  onPrimaryContainer: Colors.white,
                  onSecondary: Colors.grey.shade900,
                  onSecondaryContainer: Colors.grey.shade900,
                  tertiary: Colors.grey.shade900,
                  onTertiary: Colors.grey.shade900,
                  tertiaryContainer: Colors.grey.shade900,
                  onTertiaryContainer: Colors.grey.shade900,
                  error: Colors.grey.shade900,
                  onError: Colors.grey.shade900,
                  onBackground: Colors.grey.shade900,
                  surface: Colors.grey.shade900,
                  surfaceVariant: Colors.grey.shade900,
                  onSurfaceVariant: Colors.white,
                  outline: Colors.white,
                  outlineVariant: Colors.grey.shade900,
                  shadow: Colors.grey.shade900,
                  scrim: Colors.grey.shade900,
                  inverseSurface: Colors.grey.shade900,
                  onInverseSurface: Colors.grey.shade900,
                  inversePrimary: Colors.grey.shade900,
                  surfaceTint: Colors.grey.shade900,
                ),
              ),
              child: child!,
            ),
          );

          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            builder: (BuildContext context, Widget? child) => Theme(
              data: ThemeData(
                splashFactory: NoSplash.splashFactory,
                appBarTheme: Theme.of(context).appBarTheme.copyWith(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.white),
                scaffoldBackgroundColor: Colors.grey.shade900,
                colorScheme: ColorScheme.fromSwatch().copyWith(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                  secondary: Colors.white,
                  secondaryContainer: const Color.fromARGB(255, 45, 66, 46),
                  onSurface: Colors.white,
                  background: Colors.white,
                  primaryContainer: Colors.grey.shade900,
                  onPrimaryContainer: Colors.white,
                  onSecondary: Colors.grey.shade900,
                  onSecondaryContainer: Colors.grey.shade900,
                  tertiary: Colors.grey.shade900,
                  onTertiary: Colors.grey.shade900,
                  tertiaryContainer: Colors.grey.shade900,
                  onTertiaryContainer: Colors.grey.shade900,
                  error: Colors.grey.shade900,
                  onError: Colors.grey.shade900,
                  onBackground: Colors.grey.shade900,
                  surface: Colors.grey.shade900,
                  surfaceVariant: Colors.grey.shade900,
                  onSurfaceVariant: Colors.white,
                  outline: Colors.white,
                  outlineVariant: Colors.grey.shade900,
                  shadow: Colors.grey.shade900,
                  scrim: Colors.grey.shade900,
                  inverseSurface: Colors.grey.shade900,
                  onInverseSurface: Colors.grey.shade900,
                  inversePrimary: Colors.grey.shade900,
                  surfaceTint: Colors.grey.shade900,
                ),
              ),
              child: child!,
            ),
          );

          if (date != null && time != null) {
            _uploadScheduleTap(date, time);
          }
        },
        backgroundColor: Colors.grey.shade200,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
            child: Column(
              children: [
                TableCalendar(
                  calendarBuilders: CalendarBuilders(
                    singleMarkerBuilder: (context, date, event) {
                      CalendarEventModel calendarEvent =
                          event as CalendarEventModel;
                      return Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: calendarEvent.eventColor),
                        width: 7.0,
                        height: 7.0,
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      );
                    },
                  ),
                  calendarStyle: CalendarStyle(
                    markerDecoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    todayDecoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    // 2 weeks버튼의 textStyle을 하얀색으로 바꾸고싶어
                    formatButtonTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 14),
                    formatButtonDecoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20)),
                    rightChevronIcon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 15,
                    ),
                    leftChevronIcon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                  rowHeight: 70,
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _focusedDay = selectedDay;
                    });
                    _getSelectedDaySchedule(selectedDay);
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_focusedDay, day);
                  },
                  eventLoader: (date) {
                    String dateString = date.toString().substring(0, 10);
                    List<CalendarEventModel> filteredEvents =
                        _allEventsList.where((event) {
                      return event.date == dateString;
                    }).toList();
                    return filteredEvents;
                  },
                ),
                if (_selectedEventsList.isNotEmpty)
                  Text("${_focusedDay.toString().substring(0, 10)}のスケジュール"),
                if (_selectedEventsList.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(10),
                    itemCount: _selectedEventsList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    color: Colors.green, width: 1),
                              ),
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _selectedEventsList[index].eventColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              title: Row(
                                children: [
                                  Container(
                                    width: 220,
                                    child: Text(
                                      _selectedEventsList[index].title,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedEventsList[index].time,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const Gap(5),
                                  Text(
                                    "uploaded by ${_selectedEventsList[index].uploaderName}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              trailing: (index < _selectedEventsList.length &&
                                      _selectedEventsList[index].uploaderId ==
                                          _uid)
                                  ? IconButton(
                                      onPressed: () => _deleteSchedule(
                                        _selectedEventsList[index].createdAt,
                                      ),
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null),
                          const Gap(10),
                        ],
                      );
                    },
                  ),
                const Text("今日のスケジュール"),
                if (_todayEventsList.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(10),
                    itemCount: _todayEventsList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    color: Colors.green, width: 1),
                              ),
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _todayEventsList[index].eventColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              title: Row(
                                children: [
                                  Container(
                                    width: 220,
                                    child: Text(
                                      _todayEventsList[index].title,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _todayEventsList[index].time,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const Gap(5),
                                  Text(
                                    "uploaded by ${_todayEventsList[index].uploaderName}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              trailing: (index < _todayEventsList.length &&
                                      _todayEventsList[index].uploaderId ==
                                          _uid)
                                  ? IconButton(
                                      onPressed: () => _deleteSchedule(
                                        _todayEventsList[index].createdAt,
                                      ),
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null),
                          const Gap(10),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
