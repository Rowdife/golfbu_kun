import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:golfbu_kun/features/authentication/widgets/auth_button.dart';
import 'package:golfbu_kun/features/profile/vms/profiles_vm.dart';
import 'package:golfbu_kun/features/schedule_management/models/calendar_event_model.dart';
import 'package:golfbu_kun/features/schedule_management/repos/calendar_repo.dart';

class ScheduleUploadForm extends ConsumerStatefulWidget {
  const ScheduleUploadForm({
    super.key,
    required this.schedule,
  });

  final List<DateTime>? schedule;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScheduleUploadFormState();
}

class _ScheduleUploadFormState extends ConsumerState<ScheduleUploadForm> {
  final _formKey = GlobalKey<FormState>();

  String _scheduleName = "";
  String? _description = "";

  Color _selectedColor = Colors.white;

  void _onColorTap(Color color) {
    if (color == Colors.red) {
      setState(() {
        _selectedColor = Colors.red;
      });
    } else if (color == Colors.green) {
      setState(() {
        _selectedColor = Colors.green;
      });
    } else if (color == Colors.blue) {
      setState(() {
        _selectedColor = Colors.blue;
      });
    } else if (color == Colors.white) {
      setState(() {
        _selectedColor = Colors.white;
      });
    }
  }

  void _onSaveTap() {
    ref.read(profileProvider).whenData((value) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        final profile = value;
        final schedule = CalendarEventModel(
          scheduleStartDate: widget.schedule![0].toString().substring(0, 10),
          scheduleStartTime: widget.schedule![0].toString().substring(11, 16),
          scheduleEndDate: widget.schedule![1].toString().substring(0, 10),
          scheduleEndTime: widget.schedule![1].toString().substring(11, 16),
          title: _scheduleName,
          description: _description,
          eventColor: _selectedColor,
          uploaderName: profile.name,
          uploaderId: profile.uid,
          createdAt: DateTime.now().millisecondsSinceEpoch,
        );
        ref.read(calendarProvider).uploadSchedule(schedule);
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void initState() {
    ref.read(profileProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.grey.shade900, // Set your desired background color
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(20),
                Text(
                  widget.schedule.toString().substring(1, 17),
                  style: const TextStyle(fontSize: 20),
                ),
                const Gap(10),
                const Text("TO"),
                const Gap(10),
                Text(
                  widget.schedule.toString().substring(26, 42),
                  style: const TextStyle(fontSize: 20),
                ),
                const Gap(20),
                Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: "日程名",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "日程名を入力してください";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _scheduleName = value!;
                              },
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: "説明",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              onSaved: (value) {
                                _description = value;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    const Text("色を選択してください"),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () => _onColorTap(Colors.red),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                              border: _selectedColor == Colors.red
                                  ? Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    )
                                  : null,
                            ),
                            width: 50,
                            height: 50,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _onColorTap(Colors.green),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                              border: _selectedColor == Colors.green
                                  ? Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    )
                                  : null,
                            ),
                            width: 50,
                            height: 50,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _onColorTap(Colors.blue),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                              border: _selectedColor == Colors.blue
                                  ? Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    )
                                  : null,
                            ),
                            width: 50,
                            height: 50,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _onColorTap(Colors.white),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: _selectedColor == Colors.white
                                  ? Border.all(
                                      color: Colors.black,
                                      width: 4,
                                    )
                                  : null,
                            ),
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                    const Gap(30),
                    GestureDetector(
                        onTap: _onSaveTap,
                        child:
                            const AuthButton(color: Colors.green, text: "Save"))
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
