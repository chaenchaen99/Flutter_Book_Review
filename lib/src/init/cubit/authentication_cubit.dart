import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_book_review/src/common/model/user_model.dart';
import 'package:flutter_book_review/src/common/repository/authentication_repository.dart';
import 'package:flutter_book_review/src/common/repository/user_repository.dart';

class AuthenticationCubit extends Cubit<AuthenticationState>
    with ChangeNotifier {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  AuthenticationCubit(this._authenticationRepository, this._userRepository)
      : super(const AuthenticationState());

  void init() {
    _authenticationRepository.logout();
    _authenticationRepository.user.listen((user) {
      _userStateChangedEvent(user);
    });
  }

  void _userStateChangedEvent(UserModel? user) async {
    if (user == null) {
      emit(state.copyWith(status: AuthenticationStatus.unknown));
    } else {
      var result = await _userRepository.findUserOne(user.uid!);
      if (result == null) {
        emit(
          state.copyWith(
            user: user,
            status: AuthenticationStatus.unAuthenticated,
          ),
        );
      } else {
        emit(state.copyWith(
          user: result,
          status: AuthenticationStatus.authentication,
        ));
      }
    }

    notifyListeners();
  }

  void reloadAuth() {
    _userStateChangedEvent(state.user);
  }

  void googleLogin() async {
    await _authenticationRepository.signInWithGoogle();
  }

  void appleLogin() async {
    await _authenticationRepository.signInWithApple();
  }

  @override
  void onChange(Change<AuthenticationState> change) {
    super.onChange(change);
    print(change);
  }
}

enum AuthenticationStatus {
  authentication,
  unAuthenticated,
  unknown,
  init,
  error,
}

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final UserModel? user;
  const AuthenticationState(
      {this.status = AuthenticationStatus.init, this.user});

  AuthenticationState copyWith({
    AuthenticationStatus? status,
    UserModel? user,
  }) {
    return AuthenticationState(
        status: status ?? this.status, user: user ?? user);
  }

  @override
  List<Object?> get props => [status, user];
}
