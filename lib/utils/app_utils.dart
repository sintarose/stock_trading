import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/stock_trading_data.dart';
import '../pages/chart_screen.dart';

class AppUtils{
  // Function to navigate to ChartScreen with a custom transition
 static void navigateToChartScreen(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ChartScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

 // Function to build styled text fields
static Widget buildTextField({
   required TextEditingController controller,
   required String labelText,
   required IconData icon,
   required bool isPassword,
 }) {
   return TextFormField(
     controller: controller,
     obscureText: isPassword,
     keyboardType: isPassword
         ? TextInputType.text
         : TextInputType.emailAddress, // Email field keyboard type
     decoration: InputDecoration(
       prefixIcon: Icon(icon, color: Colors.deepPurple),
       labelText: labelText,
       labelStyle: const TextStyle(color: Colors.deepPurple),
       filled: true,
       fillColor: Colors.deepPurple[50],
       border: OutlineInputBorder(
         borderRadius: BorderRadius.circular(30),
         borderSide: BorderSide.none,
       ),
       focusedBorder: OutlineInputBorder(
         borderRadius: BorderRadius.circular(30),
         borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
       ),
       errorStyle: const TextStyle(color: Colors.redAccent),
     ),
     validator: (value) {
       if (value == null || value.isEmpty) {
         return 'Please enter your $labelText';
       }
       if (!isPassword && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
         return 'Please enter a valid email';
       }
       return null;
     },
   );
 }
}