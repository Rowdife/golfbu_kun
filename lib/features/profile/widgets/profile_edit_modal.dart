import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/authentication/widgets/auth_button.dart';
import 'package:golfbu_kun/features/profile/repos/profile_repo.dart';
import 'package:golfbu_kun/features/profile/screens/profile_screen.dart';
import 'package:golfbu_kun/features/profile/vms/profiles_vm.dart';

class ProfileEditModal extends ConsumerStatefulWidget {
  const ProfileEditModal({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileEditModalState();
}

class _ProfileEditModalState extends ConsumerState<ProfileEditModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String grade = "1年";
  String name = "";

  void _onEditTap(BuildContext context) async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        await ref
            .read(profileRepo)
            .updateProfile(userName: name, userGrade: grade);
        await ref.read(profileProvider.notifier).fetchProfile();
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ref.watch(profileProvider).when(
              data: (profile) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Gap(20),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              initialValue: profile.name,
                              decoration: const InputDecoration(
                                  labelText: '名前',
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                  )),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter some text';
                                }

                                return null;
                              },
                              onSaved: (nameValue) {
                                name = nameValue!;
                              },
                            ),
                          ),
                          const Gap(20),
                          SizedBox(
                            width: 70,
                            height: 80,
                            child: Center(
                              child: DropdownButton(
                                style: const TextStyle(fontSize: 20),
                                dropdownColor: Colors.grey.shade900,
                                value: grade,
                                onChanged: (value) {
                                  setState(() {
                                    grade = value.toString();
                                  });
                                },
                                items: const [
                                  DropdownMenuItem(
                                    value: "1年",
                                    child: Center(child: Text("1年")),
                                  ),
                                  DropdownMenuItem(
                                    value: "2年",
                                    child: Center(child: Text("2年")),
                                  ),
                                  DropdownMenuItem(
                                    value: "3年",
                                    child: Center(child: Text("3年")),
                                  ),
                                  DropdownMenuItem(
                                    value: "4年",
                                    child: Center(child: Text("4年")),
                                  ),
                                  DropdownMenuItem(
                                    value: "5年",
                                    child: Center(child: Text("5年")),
                                  ),
                                  DropdownMenuItem(
                                    value: "6年",
                                    child: Center(child: Text("6年")),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(20),
                      GestureDetector(
                        onTap: () => _onEditTap(context),
                        child: const AuthButton(
                            color: Colors.green, text: "情報を変更"),
                      ),
                    ],
                  ),
                );
              },
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              error: (error, stackTrace) => Center(
                child: Text(
                  '投稿をロードできません $error',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ));
  }
}
