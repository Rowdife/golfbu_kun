import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        .read(calendarProvider)
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

  void _getTodaySchedule() async {
    final todaySchedule = await ref
        .read(calendarProvider)
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

  void _deleteSchedule(int createdAt) async {
    await ref.read(calendarProvider).deleteSchedule(createdAt);
    _getTodaySchedule();
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
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ));
  }

  Future<void> _getAllSchedule() async {
    final allSchedule = await ref.read(calendarProvider).getAllSchedule();
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

  @override
  void initState() {
    super.initState();
    _getAllSchedule();
    _getTodaySchedule();
    _uid = ref.read(authRepo).user!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final schedule = await showOmniDateTimeRangePicker(
            context: context,
            theme: ThemeData(
              splashFactory: NoSplash.splashFactory,
              appBarTheme: Theme.of(context).appBarTheme.copyWith(
                  backgroundColor: Colors.white, foregroundColor: Colors.white),
              scaffoldBackgroundColor: Colors.grey.shade900,
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: Colors.green,
                onPrimary: Colors.white,
                secondary: Colors.white,
                secondaryContainer: const Color.fromARGB(255, 45, 66, 46),
                onSurface: Colors.white,
                background: Colors.grey.shade900,
                primaryContainer: Colors.white,
                onPrimaryContainer: Colors.white,
                onSecondary: Colors.white,
                onSecondaryContainer: Colors.white,
                tertiary: Colors.white,
                onTertiary: Colors.white,
                tertiaryContainer: Colors.white,
                onTertiaryContainer: Colors.white,
                error: Colors.white,
                onError: Colors.white,
                errorContainer: Colors.white,
                onErrorContainer: Colors.white,
                onBackground: Colors.white,
                surface: Colors.white,
                surfaceVariant: Colors.white,
                onSurfaceVariant: Colors.white,
                outline: Colors.white,
                outlineVariant: Colors.white,
                shadow: Colors.white,
                scrim: Colors.white,
                inverseSurface: Colors.white,
                onInverseSurface: Colors.white,
                inversePrimary: Colors.white,
                surfaceTint: Colors.white,
              ),
            ),
          );
          if (schedule != null) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              scrollControlDisabledMaxHeightRatio: 0.5,
              builder: (BuildContext context) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ScheduleUploadForm(schedule: schedule));
              },
            );
          }
        },
        backgroundColor: Colors.grey.shade200,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _getAllSchedule,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 1.1,
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
                      return event.scheduleStartDate == dateString;
                    }).toList();
                    return filteredEvents;
                  },
                ),
                if (_selectedEventsList.isNotEmpty)
                  Text("${_focusedDay.toString().substring(0, 10)}のスケジュール"),
                if (_selectedEventsList.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _selectedEventsList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
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
                              Text(
                                _selectedEventsList[index].title,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const Gap(20),
                              Text(
                                "${_selectedEventsList[index].scheduleStartTime} ~ ${_selectedEventsList[index].scheduleEndTime}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                "uploaded by ${_selectedEventsList[index].uploaderName}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          trailing: (index < _selectedEventsList.length &&
                                  _selectedEventsList[index].uploaderId == _uid)
                              ? IconButton(
                                  onPressed: () => _deleteSchedule(
                                    _selectedEventsList[index].createdAt,
                                  ),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                )
                              : null);
                    },
                  ),
                const Text("今日のスケジュール"),
                if (_todayEventsList.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _todayEventsList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
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
                              Text(
                                _todayEventsList[index].title,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const Gap(20),
                              Text(
                                "${_todayEventsList[index].scheduleStartTime} ~ ${_todayEventsList[index].scheduleEndTime}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                "uploaded by ${_todayEventsList[index].uploaderName}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          trailing: (index < _todayEventsList.length &&
                                  _todayEventsList[index].uploaderId == _uid)
                              ? IconButton(
                                  onPressed: () => _deleteSchedule(
                                    _todayEventsList[index].createdAt,
                                  ),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                )
                              : null);
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
