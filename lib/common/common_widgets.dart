import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';

class CustomDialog{
  static void showLoading(BuildContext context, String title) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 12,),
            Text(
              title,
              style: GoogleFonts.lexend(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: true,
    ).show();
  }
  static void cancelLoading() {
    Get.back();
  }

  static void showAlert(
      BuildContext context, String dialogMessage, bool success, double? fontSize) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  success ? Icons.check_circle : Icons.clear,
                  color: success ? Colors.green : Colors.red,
                  size: 40,
                ),
                const SizedBox(height: 15),
                Text(
                  dialogMessage,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lexend(
                      fontSize: fontSize ?? 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )
              ],
            ),
            actions: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey)),
                child: TextButton(
                  child: Text(
                      'OK',
                      style: GoogleFonts.lexend(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                  onPressed: () {
                    Navigator.pop(context);//Close Dialog Box
                  },
                ),
              ),
            ],
          );
        });
  }

  static void okActionAlert(
      BuildContext context, String dialogMessage, bool success, double? fontSize, VoidCallback okAction) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  success ? Icons.check_circle : Icons.clear,
                  color: success ? Colors.green : Colors.red,
                  size: 40,
                ),
                const SizedBox(height: 15),
                Text(
                  dialogMessage,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lexend(
                      fontSize: fontSize ?? 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )
              ],
            ),
            actions: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey)),
                child: TextButton(
                  onPressed: okAction ,
                  child: Text(
                      'OK',
                      style: GoogleFonts.lexend(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                ),
              ),
            ],
          );
        });
  }
}

BoxDecoration decoration() => BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
      color: const Color(0xffD6D6D6),
    ));


Future yesOrNoDialog({required BuildContext context, required String dialogMessage, required String cancelText, required String okText, required VoidCallback okAction}) {
  return  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.info,
                color: Colors.red,
                size: 40,
              ),
              const SizedBox(height: 15),
              Text(
                dialogMessage,
                textAlign: TextAlign.center,
                style: GoogleFonts.lexend(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              )
            ],
          ),
          actionsPadding: EdgeInsets.only(bottom: 8, right: 8),
          actions: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey)),
              child: TextButton(
                child: Text(cancelText,
                    style: GoogleFonts.lexend(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
                onPressed: () {
                  Navigator.pop(context);//Close Dialog Box
                },
              ),
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red)),
              child: TextButton(
                onPressed: okAction,
                child: Text(okText,
                    style: GoogleFonts.lexend(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.red)),
              ),
            ),
          ],
        );
      });
}

Widget text14213({required String title, Color? textColor}) {
  return Text(
    title,
    overflow: TextOverflow.ellipsis,
    style: GoogleFonts.lexend(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: textColor,
    ),
  );
}

Widget squareCardNetworkImageButton({required String imagePath, required BuildContext context, required String title, VoidCallback? onPressed}){
  return Material(
    borderRadius: BorderRadius.circular(12),
    elevation: 2,
    child: GestureDetector(
      onTap: onPressed,
      child: Container(
        height: MediaQuery.of(context).size.width * 0.4,
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F6F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 60,
                width: 60,
                child: Image.network(imagePath)),
            const SizedBox(height: 5),
            subHeading(text: title)
          ],
        ),
      ),
    ),
  );
}


class PrimaryInputText extends StatelessWidget {
  final String hintText;
  final String? Function(String? value) onValidate;
  final String? Function(String? value)? onChange;
  final TextEditingController? controller;
  final bool isEnabled;
  final int maxLines;
  final int? maxLength;
  final Widget? suffixImage;
  final TextInputType textInputType;
  final FocusNode? focusNode;
  final bool? readOnly;
  final bool? obscureText;
  final String? value;
  const PrimaryInputText({Key? key,this.obscureText,this.value, required this.hintText,this.readOnly, this.controller, required this.onValidate,this.isEnabled = true, this.textInputType = TextInputType.text, this.maxLines=1,this.maxLength, this.onChange, this.suffixImage, this.focusNode}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      readOnly: readOnly ?? false,
      style: GoogleFonts.lexend(color: Colors.black),
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText ?? false,
      validator: onValidate,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: isEnabled,
      onChanged: onChange,
      keyboardType: textInputType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16),
        counterText: "",
        labelText: hintText,
        suffixIcon: suffixImage,
        labelStyle: GoogleFonts.lexend(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black54
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xff000000),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final String? Function(String? value)? onChange;
  final TextEditingController? searchController;
  const CustomSearchBar({Key? key,  required this.hintText, this.onChange, this.searchController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onChanged: onChange,
        showCursor: true,
        controller: searchController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xffD6D6D6),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 25,
            color: Color(0xff858585),
          ),
          hintText: hintText,
          hintStyle: GoogleFonts.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xffADADAD),
          ),
        ),
      );
  }
}

Widget commonColorButton(
    {required String title,
      required Color textColor,
      required Color buttonColor,
      required VoidCallback onPressed}) {
  return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(buttonColor),
          padding:
          MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 8)),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            // side: const BorderSide(color: Color(0xff979797)),
              borderRadius: BorderRadius.circular(8)))),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          title,
          style: GoogleFonts.lexend(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
}

Widget fullColorButton(
    {required String title,
      required Color textColor,
      required Color buttonColor,
      required BuildContext context,
      required VoidCallback onPressed}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 1,
    height: 45,
    child: ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(buttonColor),
          padding:
          MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 14, horizontal: 8)),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            // side: const BorderSide(color: Color(0xff979797)),
              borderRadius: BorderRadius.circular(8)))),
      onPressed: onPressed,
      child: Text(
        title,
        style: GoogleFonts.lexend(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    ),
  );
}

Widget centerPara({required String text, Color? color}){
  return Text(text,
      textAlign: TextAlign.center,
      style: GoogleFonts.lexend(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color ?? Colors.black,
      ));
}


Widget paragraph({required String text, Color? color, double? size}){
  return Text(text,
      style: GoogleFonts.lexend(
    fontSize: size ?? 12,
    fontWeight: FontWeight.w400,
    color: color ?? Colors.black,
  ));
}

Widget subPara({required String text, Color? color, double? size}){
  return Text(text, style: GoogleFonts.lexend(
    fontSize: size ?? 10,
    fontWeight: FontWeight.w400,
    color: color ?? Colors.black,
  ));
}

Widget posterHeading({required String text, Color? color}){
  return Text(text, style: GoogleFonts.lexend(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: color ?? Colors.black,
  ));
}

Widget underLineButton({required VoidCallback onPressed, required String text, Color? color, double? size}){
  return GestureDetector(
    onTap: onPressed,
    child: Text(text, style: GoogleFonts.lexend(
      decoration: TextDecoration.underline,
      fontSize: size ?? 14,
      fontWeight: FontWeight.bold,
      color: color ?? Colors.black,
    )),
  );
}

Widget heading({required String text, Color? color}){
  return Text(text, style: GoogleFonts.lexend(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: color ?? Colors.black,
  ));
}

Widget adjustFont({required String text,TextAlign? textAlign, Color? color, double? fontSize}){
  return Text(text,
      textAlign: textAlign,
      style: GoogleFonts.lexend(
    fontSize: fontSize ?? 16,
    fontWeight: FontWeight.w500,
    color: color ?? Colors.black,
  ));
}


Widget iconText({required String text, Color? iconColor,double? iconSize,required IconData icon,  double? fontSize}){
  return Row(
    children: [
      Icon(
        icon,
        size: iconSize ?? 16,
        color: iconColor ?? Colors.black,
      ),
      const SizedBox(width: 10),
      adjustFont(text: text, fontSize: fontSize ?? 16)
    ],
  );
}

Widget subHeading({required String text, Color? color, double? size}){
  return Text(text, style: GoogleFonts.lexend(
    fontSize: size ?? 14,
    fontWeight: FontWeight.w500,
    color: color ?? Colors.black,
  ));
}

Widget fullIconColorButton(
    {required String title,
      required Color textColor,
      required Color buttonColor,
      required BuildContext context,
      required VoidCallback onPressed,
      required String iconUrl}) {
  return Container(
    height: 45,
    width: MediaQuery.of(context).size.width * 1,
     child: ElevatedButton(
       style: ButtonStyle(
         backgroundColor: MaterialStateProperty.all(buttonColor),
         padding:
         MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 12)),
         elevation: MaterialStateProperty.all(0),
         shape: MaterialStateProperty.all(
           RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(8),
           ),
         ),
       ),
       onPressed: onPressed,
       child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           SvgPicture.asset(iconUrl),
           const SizedBox(
             width: 8,
           ),
           Text(
             title,
             style: GoogleFonts.lexend(
               fontSize: 15,
               fontWeight: FontWeight.w500,
               color: const Color(0xff000000),
             ),
           ),
         ],
       ),

     ),
  );
}

Widget commonIconColorButton(
    {required String title,
      required Color textColor,
      required Color buttonColor,
      required VoidCallback onPressed,
      required String iconUrl}) {
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(buttonColor),
      padding:
      MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 12)),
      elevation: MaterialStateProperty.all(0),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    onPressed: onPressed,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(iconUrl),
        const SizedBox(
          width: 8,
        ),
        Text(
          title,
          style: GoogleFonts.lexend(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: const Color(0xffFFFFFF),
          ),
        ),
      ],
    ),

  );
}
