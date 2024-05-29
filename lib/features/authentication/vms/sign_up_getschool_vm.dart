import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';

class GetSchoolListViewModel extends AsyncNotifier<List<DropdownMenuEntry>> {
  late final AuthenticationRepository _authRepo;

  Future<List<DropdownMenuEntry>> _getUniversities() async {
    final universities = await _authRepo.getUniversities();
    final List<DropdownMenuEntry> list = [];
    for (Map school in universities) {
      list.add(
        DropdownMenuEntry(
          value: [school.keys.first, school.values.first],
          label: school.values.first,
        ),
      );
    }
    return list;
  }

  @override
  FutureOr<List<DropdownMenuEntry>> build() async {
    _authRepo = ref.read(authRepo);
    state = const AsyncValue.loading();
    final schoolNameList = await _getUniversities();
    state = AsyncValue.data(schoolNameList);
    return schoolNameList;
  }

  Future<Map> getUniversityNameList() async {
    final universities = await _authRepo.getUniversities();
    final Map dic = {};
    for (int i = 0; i < universities.length; i++) {
      dic.addAll({universities[i].keys.first: universities[i].values.last});
    }
    return dic;
  }
}

final getSchoolListProvider =
    AsyncNotifierProvider<GetSchoolListViewModel, List<DropdownMenuEntry>>(
  () => GetSchoolListViewModel(),
);
