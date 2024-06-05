import 'package:flutter/material.dart';
import 'package:catsnap/bottom_nav_bar.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatelessWidget {
  static String id = "SplashScreen";
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
   return   Scaffold(
      backgroundColor: Colors.white,
     body: Stack(
       children: [
         const Positioned.fill( // Cover entire screen
           child: Image(
             image: AssetImage('Images/CAT2.jpg'),
             fit: BoxFit.cover, // Adjust fit as needed
           ),
         ),
         Positioned(
           bottom: 0,
           left: 0,
           right: 0,
         child: Column(
           children: [
             const SizedBox(height: 50,),
             Center(
               child: InkWell(
                 onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNavBar()),
                   );
                   },
                 child: Container(
                   height: 50,
                   width: 350,
                   decoration: BoxDecoration(
                     border: Border.all(
                       color: const Color.fromARGB(255, 99, 181, 248),
                       width: 2
                     ),
                     borderRadius: BorderRadius.circular(20.0), // Set the desired radius
                     color: Colors.white, // Set the container color
                   ),
                   child:  Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Shimmer.fromColors(
                           baseColor: const Color.fromARGB(255, 145, 205, 255),
                           highlightColor: const Color.fromARGB(255, 255, 141, 179),
                           child:  const Text("Get Started",
                               style: TextStyle(
                                 fontSize: 25,
                                 fontWeight: FontWeight.bold,
                               ),),),
                       const SizedBox(width: 15,),
                       Shimmer.fromColors(
                         baseColor: Color.fromARGB(255, 145, 205, 255),
                         highlightColor: Color.fromARGB(255, 255, 141, 179),
                         child:  const Icon(Icons.star
                         ,color: Colors.black,
                         ),),
                   ],),
                 ),
               ),
             ),
             const SizedBox(height: 25,),
           ],
          ),
         ),
       ],
     ),
    );
  }
}
