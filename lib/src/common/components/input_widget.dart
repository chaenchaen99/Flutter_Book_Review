import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InputWidget extends StatelessWidget {
  final bool isEnabled;
  final Function()? onTap;
  const InputWidget({
    super.key,
    this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color(0xff232323),
        ),
        child: Row(
          children: [
            SvgPicture.asset('assets/svg/icons/icon_serarch.svg'),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: '검색어를 입력해주세요',
                  hintStyle: const TextStyle(
                    color: Color(0xff585858),
                  ),
                  enabled: !isEnabled,
                  contentPadding: const EdgeInsets.only(left: 10),
                  enabledBorder:
                      const UnderlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      const UnderlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
