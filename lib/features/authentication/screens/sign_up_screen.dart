import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/common/main_navigation/screen/main_navigation_screen.dart';
import 'package:golfbu_kun/features/authentication/vms/sign_up_getschool_vm.dart';
import 'package:golfbu_kun/features/authentication/vms/sign_up_vm.dart';
import 'package:golfbu_kun/features/authentication/widgets/auth_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  static const routeName = "SignUp";
  static const routeURL = "/signup";
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  bool isButtonDisabled = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Map<String, String> formData = {};
  Map<String, String> passwordConfirmation = {};
  void onSignUpTap(BuildContext context) async {
    bool allMenuesAreSelected = formData["university"] != null &&
        formData["position"] != null &&
        formData["sex"] != null &&
        formData["grade"] != null;

// 大学、役職、性別のメニューを全て選択させてから　FormをSaveする。
    if (!allMenuesAreSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("大学、役職、性別を全てご入力ください"),
        ),
      );
    } else {
      if (formKey.currentState != null) {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          ref.read(signUpForm.notifier).state = {
            "university": formData["university"],
            "universityId": formData["universityId"],
            "position": formData["position"],
            "grade": formData["grade"],
            "sex": formData["sex"],
            "name": formData["name"],
            "email": formData["email"],
            "password": formData["passwordConfirm"]
          };
          setState(() {
            isButtonDisabled = true;
          });
        }
      }
    }
    await ref.read(signUpProvider.notifier).signUp(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuEntry<dynamic>> university = [];

    List<DropdownMenuEntry<dynamic>> position = [
      const DropdownMenuEntry(value: "部員", label: "部員"),
      const DropdownMenuEntry(value: "幹部", label: "幹部"),
      const DropdownMenuEntry(value: "コーチ", label: "コーチ"),
      const DropdownMenuEntry(value: "監督", label: "監督")
    ];

    List<DropdownMenuEntry<dynamic>> sex = [
      const DropdownMenuEntry(value: "男子部員", label: "男性"),
      const DropdownMenuEntry(value: "女子部員", label: "女性"),
      const DropdownMenuEntry(value: "LGBTQ+", label: "LGBTQ+"),
      const DropdownMenuEntry(value: "その他", label: "その他"),
      const DropdownMenuEntry(value: "無回答", label: "無回答"),
    ];

    List<DropdownMenuEntry<dynamic>> grade = [
      const DropdownMenuEntry(value: "1年", label: "1年"),
      const DropdownMenuEntry(value: "2年", label: "2年"),
      const DropdownMenuEntry(value: "3年", label: "3年"),
      const DropdownMenuEntry(value: "4年", label: "4年"),
      const DropdownMenuEntry(value: "5年", label: "5年"),
      const DropdownMenuEntry(value: "6年", label: "6年"),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("会員登録"),
      ),
      body: ref.watch(getSchoolListProvider).when(
        data: (data) {
          final schoolList = data;
          return SafeArea(
            child: GestureDetector(
              onTap: () {},
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(10),
                        DropdownMenu(
                          enableFilter: true,
                          requestFocusOnTap: true,
                          onSelected: (newValue) {
                            formData["university"] = newValue[1];
                            formData["universityId"] = newValue[0];
                          },
                          label: const Text(
                            "学校",
                            style: TextStyle(color: Colors.white),
                          ),
                          dropdownMenuEntries: schoolList,
                        ),
                        const Gap(10),
                        Text("自分の所属している学校でも利用したい場合は\n以下に連絡ください。"),
                        Row(
                          children: [
                            Text("Mail: "),
                            GestureDetector(
                              onTap: () async {
                                await launchUrl(
                                  Uri(
                                    scheme: 'mailto',
                                    path: 'golfosusume@gmail.com',
                                    queryParameters: {
                                      'subject': 'ゴルフ部くん利用申請',
                                      'body':
                                          "XX大学/XX高校ゴルフ部でゴルフ部くんを利用したいです\n連絡先はこちらになります。\nMail:XXXXX@XXXXX.com\nInstagram:@XXXXXXX\nでお願いします"
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                "golfosusume@gmail.com",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Instagram: "),
                            GestureDetector(
                              onTap: () async {
                                await launchUrlString(
                                    "https://www.instagram.com/golfbu_kun");
                              },
                              child: Text(
                                "@golfbu_kun",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                        DropdownMenu(
                          onSelected: (newValue) {
                            formData["position"] = newValue;
                          },
                          label: const Text(
                            "役職",
                            style: TextStyle(color: Colors.white),
                          ),
                          dropdownMenuEntries: position,
                        ),
                        const Gap(10),
                        DropdownMenu(
                          onSelected: (newValue) {
                            formData["sex"] = newValue;
                          },
                          label: const Text(
                            "性別",
                            style: TextStyle(color: Colors.white),
                          ),
                          dropdownMenuEntries: sex,
                        ),
                        const Gap(10),
                        DropdownMenu(
                          onSelected: (newValue) {
                            formData["grade"] = newValue;
                          },
                          label: const Text(
                            "学年",
                            style: TextStyle(color: Colors.white),
                          ),
                          dropdownMenuEntries: grade,
                        ),
                        const Gap(10),
                        const Text("お名前をフルネームでご入力ください。(例: Ishikawa Ryo)"),
                        const Gap(10),
                        TextFormField(
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(color: Colors.cyanAccent),
                          ),
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return "名前を入力してください";
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            if (newValue != null) {
                              formData["name"] = newValue;
                            }
                          },
                        ),
                        const Gap(10),
                        const Text("メールアドレスをご入力ください。IDとしてご利用いただきます。"),
                        const Gap(10),
                        TextFormField(
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(color: Colors.cyanAccent),
                          ),
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return "メールアドレスを入力してください";
                            } else if (!EmailValidator.validate(value!)) {
                              return "メールアドレスを正しく入力してください";
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            if (newValue != null) {
                              formData["email"] = newValue;
                            }
                          },
                        ),
                        const Gap(10),
                        const Text("パスワードをご入力ください"),
                        const Gap(10),
                        TextFormField(
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(color: Colors.cyanAccent),
                          ),
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return "パスワードを入力してください";
                            } else if (value!.length < 6) {
                              return "6文字以上";
                            }
                            return null;
                          },
                          obscureText: true,
                          onChanged: (newValue) {
                            passwordConfirmation["pw1"] = newValue;
                          },
                          onSaved: (newValue) {
                            if (newValue != null) {
                              formData["password"] = newValue;
                            }
                          },
                        ),
                        const Gap(10),
                        const Text("もう一度パスワードをご入力ください"),
                        const Gap(10),
                        TextFormField(
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(color: Colors.cyanAccent),
                          ),
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return "パスワードを入力してください";
                            }
                            if (passwordConfirmation["pw1"] !=
                                passwordConfirmation["pw2"]) {
                              return "全項目と同じパスワードを入力してください";
                            }
                            return null;
                          },
                          obscureText: true,
                          onChanged: (newValue) {
                            passwordConfirmation["pw2"] = newValue;
                          },
                          onSaved: (newValue) {
                            if (newValue != null) {
                              formData["passwordConfirm"] = newValue;
                            }
                          },
                        ),
                        const Gap(30),
                        Center(
                          child: GestureDetector(
                              onTap: () => onSignUpTap(context),
                              child: const AuthButton(
                                color: Colors.green,
                                text: "会員登録",
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stack) {
          return Center(
            child: Text(error.toString()),
          );
        },
      ),
    );
  }
}
