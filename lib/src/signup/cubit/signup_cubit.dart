import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(const SignupState());

  void changeProfileImage(XFile? image) {
    if (image == null) return;
    var file = File(image.path);
    emit(state.copyWith(profileFile: file));
  }

  void changeNickName(String nickname) {
    emit(state.copyWith(nickname: nickname));
  }

  void changeDescription(String description) {
    emit(state.copyWith(description: description));
  }

  void save() {
    if (state.nickname == null || state.nickname == '') return;
    if (state.profileFile != null) {
    } else {}
  }
}

class SignupState extends Equatable {
  final File? profileFile;
  final String? nickname;
  final String? description;

  const SignupState({
    this.profileFile,
    this.nickname,
    this.description,
  });

  SignupState copyWith(
      {File? profileFile, String? nickname, String? description}) {
    return SignupState(
      profileFile: profileFile ?? this.profileFile,
      nickname: nickname ?? this.nickname,
      description: description ?? description,
    );
  }

  @override
  List<Object?> get props => [profileFile, nickname, description];
}
