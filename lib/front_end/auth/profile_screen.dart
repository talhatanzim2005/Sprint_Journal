import 'package:flutter/material.dart';
import '../../backend/auth_service.dart';
import 'sign_in_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  late final String name;
  late final String email;
  final String aboutMe = 'CSE Student';
  final String journalStarted = 'August 2026';
  final int journalEntries = 0;

  @override
  void initState() {
    super.initState();
    final user = AuthService.instance.currentUser;
    name = user?.displayName ?? 'User';
    email = user?.email ?? '';
  }

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

       body: Padding(
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
             const SizedBox(height:450),
             Row(
               children: [
                 Expanded(
                     child: ElevatedButton(
                         style:ElevatedButton.styleFrom(
                           backgroundColor: const Color(0xFFDC143C),
                           foregroundColor: Colors.white,

                         ),
                       onPressed:(){

                     },
                       child: const  Text('My Journal'),
                     ),
                 ),
                 SizedBox(width: 60),
                 Expanded(
                   child: ElevatedButton(
                     style:ElevatedButton.styleFrom(
                         backgroundColor:const Color(0xFFDC143C),
                         foregroundColor: Colors.white
                     ),
                     onPressed: () async {
                       await AuthService.instance.signOut();
                       if (mounted) {
                         Navigator.pushAndRemoveUntil(
                           context,
                           MaterialPageRoute(builder: (context) => const SignInScreen()),
                           (route) => false,
                         );
                       }
                     },
                     child: const Text('Log Out'),

                   ),
                 ),
               ],
             ),
           ],
         ),
       )
     );
   }
 }