import 'package:flutter/material.dart';

class AgopTextField extends StatelessWidget {

  final String label;
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final Color? fillColor;

  const AgopTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.suffixIcon,
    this.fillColor
});

  @override
  Widget build(BuildContext context) {

    final labelStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Color(0xFF3F4942),
      letterSpacing: 1.2,
    );

    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: Color(0xFFBFC9BF)
      ),
    );


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: labelStyle,
        ),
        SizedBox(height: 6,),

        TextFormField(
          controller: controller,
          obscureText: isPassword,
          style: TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: fillColor ?? Color(0xFFF8F3E9),
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.all(18),
            enabledBorder: baseBorder,
            focusedBorder: baseBorder.copyWith(
              borderSide: BorderSide(color: Color(0xFF2D7453), width: 1.5),
            ),

            border: baseBorder,
          ),
        )
      ],
    );
  }
}
