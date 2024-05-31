import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_book_review/src/common/components/app_font.dart';
import 'package:flutter_book_review/src/init/cubit/authentication_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: Container(
          padding: const EdgeInsets.all(10.0),
          child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
              builder: (context, state) {
            return Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: state.user?.profile == null
                      ? Image.asset('assets/images/default_avatar.png').image
                      : Image.network(state.user!.profile!).image,
                ),
                const SizedBox(
                  width: 13,
                ),
                AppFont(
                  state.user?.name ?? '',
                  fontSize: 16,
                ),
              ],
            );
          }),
        ),
      ),
      body: const Center(
        child: AppFont('HOME'),
      ),
    );
  }
}
