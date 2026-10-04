import 'package:flutter/material.dart';
import '../../backend/user_service.dart';
import '../journal/journal_service.dart';
import '../journal/my_journal_list_screen.dart';
import 'sign_in_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _journalStartedController;
  final String aboutMe = 'CSE Student';
  int get journalEntries => JournalService.instance.entries.length;

  @override
  void initState() {
    super.initState();
    _journalStartedController = TextEditingController(
      text: UserService.instance.journalStarted,
    );
  }

  @override
  void dispose() {
    _journalStartedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userService = UserService.instance;

    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1B1A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'My Profile',
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
                  'Name:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    userService.fullName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'E-mail:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    userService.email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'About Me :',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    userService.aboutMe,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Journal Started :',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _journalStartedController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      hintText: 'e.g. August 2026',
                      hintStyle: TextStyle(color: Colors.white38, fontSize: 20),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFCD0033)),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFCD0033)),
                      ),
                    ),
                    onChanged: (val) {
                      userService.updateJournalStarted(val);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'Journal Entries :',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  journalEntries.toString(),
                  style: const TextStyle(
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyJournalListScreen(),
                      ),
                    );
                  },
                  child: const Text('My Journal'),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC143C),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text('Log Out'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}