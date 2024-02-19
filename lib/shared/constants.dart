import 'package:flutter/material.dart';

var textInputDecoration = InputDecoration(
    labelStyle: const TextStyle(
        fontFamily: 'JosefinSans', color: Color.fromARGB(255, 68, 158, 115)),
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.white, width: 2.0)),
    focusedBorder: const OutlineInputBorder(
        borderSide:
            BorderSide(color: Color.fromARGB(255, 68, 158, 115), width: 2.0)));

// Widget profileDrawer(BuildContext context) {
//   return Drawer(
//     child: SingleChildScrollView(
//         child: Container(
//       child: Column(
//         children: [
//           Container(
//             color: Color.fromARGB(255, 78, 181, 131),
//             width: double.infinity,
//             height: 200,
//             padding: EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(bottom: 10),
//                   height: 100,
//                   decoration: BoxDecoration(
//                       border: Border.all(width: 2.0, color: Colors.white),
//                       shape: BoxShape.circle,
//                       image: DecorationImage(
//                           image: AssetImage('assets/images/soil.png'))),
//                 ),
//                 Text('Name',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 20.0,
//                         fontFamily: 'JosefinSans')),
//                 Text(
//                   'devjain8871@gmail.com',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w200,
//                       fontSize: 15.0,
//                       fontFamily: 'JosefinSans'),
//                 )
//               ],
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.only(top: 15.0),
//             child: Column(
//               children: [
//                 menuItem("Edit Profile", Icons.edit_note_sharp, () {
//                   Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) => IntroSliderPage()));
//                 }),
//                 menuItem("Change Language", Icons.text_format, () {}),
//                 menuItem("How to use", Icons.question_answer_outlined, () {}),
//                 menuItem("About Us", Icons.info, () {})
//               ],
//             ),
//           )
//         ],
//       ),
//     )),
//   );
// }

Widget menuItem(String title, IconData menuIcon, Function ontap) {
  return Material(
    child: InkWell(
      onTap: ontap(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          Padding(
              padding: const EdgeInsets.all(18.0),
              child: Icon(
                menuIcon,
                size: 25.0,
                color: Colors.black54,
              )),
          Expanded(
              child: Text(
            title,
            style: const TextStyle(
                color: Colors.black54, fontSize: 16, fontFamily: 'JosefinSans'),
          ))
        ]),
      ),
    ),
  );
}
