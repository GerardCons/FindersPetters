import 'package:flutter/material.dart';

class UserPictureContainer extends StatelessWidget {
  const UserPictureContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xffD9D9D9),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 20, offset: Offset(5, 5))
          ]),
      child: Icon(
        Icons.person,
        color: Colors.white,
        size: 120.0,
      ),
    );
  }
}
