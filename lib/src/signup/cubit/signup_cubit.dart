import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_book_review/src/common/model/user_model.dart';
import 'package:image_picker/image_picker.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(UserModel userModel) : super(SignupState(userModel: userModel));

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

  void uploadPercent(String percent) {
    emit(state.copyWith(percent: percent));
  }

  void updateProfileImageUrl(String url) {
    emit(
      state.copyWith(
        status: SignupStatus.loading,
        userModel: state.userModel!.copyWith(profile: url),
      ),
    );
  }

  void save() {
    if (state.nickname == null || state.nickname == '') return;
    emit(state.copyWith(status: SignupStatus.loading));
    if (state.profileFile != null) {
      emit(state.copyWith(status: SignupStatus.uploading));
    } else {}
  }
}

enum SignupStatus {
  init,
  loading,
  uploading,
  success,
  fail,
}

class SignupState extends Equatable {
  final File? profileFile;
  final String? nickname;
  final String? description;
  final SignupStatus status;
  final String? percent;
  final UserModel? userModel;

  const SignupState({
    this.profileFile,
    this.nickname,
    this.description,
    this.status = SignupStatus.init,
    this.percent,
    this.userModel,
  });

  SignupState copyWith(
      {File? profileFile,
      String? nickname,
      String? description,
      SignupStatus? status,
      String? percent,
      UserModel? userModel}) {
    return SignupState(
      profileFile: profileFile ?? this.profileFile,
      nickname: nickname ?? this.nickname,
      description: description ?? this.description,
      status: status ?? this.status,
      percent: percent ?? this.percent,
      userModel: userModel ?? this.userModel,
    );
  }

  @override
  List<Object?> get props =>
      [profileFile, nickname, description, status, percent, userModel];
}
