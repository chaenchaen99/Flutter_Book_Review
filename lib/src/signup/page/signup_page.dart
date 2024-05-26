import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_book_review/src/common/components/app_font.dart';
import 'package:flutter_book_review/src/common/components/btn.dart';
import 'package:flutter_book_review/src/signup/cubit/signup_cubit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
          child: GestureDetector(
            onTap: () {},
            child: SvgPicture.asset('assets/svg/icons/icon_close.svg'),
          ),
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          _UserProfileImageField(),
          const SizedBox(height: 50),
          const _NicknameField(),
          const SizedBox(height: 30),
          const _DiscriptionField(),
        ]),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20 + MediaQuery.of(context).padding.bottom,
          top: 20,
        ),
        child: Row(
          children: [
            Expanded(
              child: Btn(
                onTap: () {
                  context.read<SignupCubit>().save;
                },
                text: '가입',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Btn(
                onTap: () {},
                backgroundColor: const Color(0xff212121),
                text: '취소',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserProfileImageField extends StatelessWidget {
  _UserProfileImageField({super.key});
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var profileFile =
        context.select<SignupCubit, File?>((cubit) => cubit.state.profileFile);

    return Center(
      child: GestureDetector(
        onTap: () async {
          var image = await _picker.pickImage(source: ImageSource.gallery);
          context.read<SignupCubit>().changeProfileImage(image);
        },
        child: CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 50,
          backgroundImage: profileFile == null
              ? Image.asset('assets/images/default_avatar.png').image
              : Image.file(profileFile).image,
        ),
      ),
    );
  }
}

class _NicknameField extends StatelessWidget {
  const _NicknameField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppFont(
          '닉네임',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 15),
        TextField(
          onChanged: context.read<SignupCubit>().changeNickName,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xff232323),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              gapPadding: 0,
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              gapPadding: 0,
              borderSide: BorderSide.none,
            ),
          ),
        )
      ],
    );
  }
}

class _DiscriptionField extends StatelessWidget {
  const _DiscriptionField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppFont(
          '한줄 소개',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 15),
        TextField(
          onChanged: context.read<SignupCubit>().changeDescription,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          maxLength: 50,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xff232323),
            counterStyle: const TextStyle(color: Colors.white, fontSize: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              gapPadding: 0,
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              gapPadding: 0,
              borderSide: BorderSide.none,
            ),
          ),
        )
      ],
    );
  }
}
