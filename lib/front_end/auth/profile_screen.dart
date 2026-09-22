import 'package:flutter/material.dart';
import '../../backend/auth_service.dart';
import '../journal/journal_screen.dart';
import 'sign_in_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
 class _ProfileScreenState extends State<ProfileScreen>
 {
   String name='Rabeta Zannat';
   String email='rabeta@gmail.com';
   String aboutMe='CSE Student';
   String journalStarted = 'August 2026';
   int journalEntries = 0;


   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: const Color(0xFF1B1B1A),
       appBar: AppBar(
         backgroundColor: Color(0xFF1B1B1A),
         leading:IconButton(
               icon: const Icon(Icons.arrow_back, color:Colors.white),
               onPressed: (){
                 Navigator.pop(context);
               },
             ),
         title:const Text('My Profile',
               style: TextStyle(
                 color: Colors.white,
               ),
             ),
       ),

       body: SingleChildScrollView(
         padding: const EdgeInsets.all(20),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Row(
               children: [
                 const Text(
                   'Name:', style: TextStyle(
                   color: Colors.white,
                   fontSize: 25,
                   fontWeight: FontWeight.bold,
                  ),
                 ),
                 SizedBox(width: 10),
                 Text(name,
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 25,

                   ),
                 ),
               ],
             ),
             const SizedBox(height:20),
             Row(
               children: [
                 const Text('E-mail:',
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 25,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
                 SizedBox(width: 10),
                  Text(email,
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 25,

                   ),
                 ),
               ],
             ),
              SizedBox(height: 20),
             Row(
               children: [
                 Text(
                   'About Me :',
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 25,
                     fontWeight: FontWeight.bold,
                   ),
                 ),

                 SizedBox(width: 10),
                 Text(
                   aboutMe,
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 25,
                   ),
                 ),
               ],
             ),
             const SizedBox(height: 20),
             Row(
               children: [
                 Text(
                   'Journal Started :',
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 25,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
                 SizedBox(width: 10),
                 Text(
                   journalStarted,
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 25,
                   ),
                 ),
               ],
             ),
             const SizedBox(height: 20),
             Row(
               children: [
                 Text(
                   'Journal Entries :',
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 25,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
                 SizedBox(width: 10),
                 Text(
                   journalEntries.toString(),
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 25,
                   ),
                 ),
               ],
             ),
             const SizedBox(height: 40),
             Column(
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: [
                 ElevatedButton(
                   style: ElevatedButton.styleFrom(
                     backgroundColor: const Color(0xFFDC143C),
                     foregroundColor: Colors.white,
                   ),
                   onPressed: () {},
                   child: const Text('My Journal'),
                 ),
                 const SizedBox(height: 15),
                 ElevatedButton(
                   style: ElevatedButton.styleFrom(
                     backgroundColor: const Color(0xFFDC143C),
                     foregroundColor: Colors.white,
                   ),
                   onPressed: () {},
                   child: const Text('Log Out'),
                 ),
               ],
             ),
           ],
         ),
       )
     );
   }
 }