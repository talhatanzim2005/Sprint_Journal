import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = 'Rabeta Zannat';
  String email = 'rabeta@gmail.com';

  IconData profileIcon = Icons.person;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1B1A),

        title: const Text('My Profile', style: TextStyle(color: Colors.white)),

        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.white,

              child: Icon(profileIcon, size: 65, color: Colors.black),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                _changeProfilePicture();
              },
              child: const Text('Change Picture'),
            ),

            const SizedBox(height: 15),

            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              email,
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),

            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: const [
                    Text(
                      '24',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text('Journals', style: TextStyle(color: Colors.white70)),
                  ],
                ),

                Column(
                  children: const [
                    Text(
                      '7',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text('Day Streak', style: TextStyle(color: Colors.white70)),
                  ],
                ),

                Column(
                  children: const [
                    Text(
                      '12',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text('Goals', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                  _editProfile();
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCD0033),
                  foregroundColor: Colors.white,
                ),

                child: const Text('Edit Profile'),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCD0033),
                  foregroundColor: Colors.white,
                ),

                child: const Text('Settings'),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logout coming soon')),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCD0033),
                  foregroundColor: Colors.white,
                ),

                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editProfile() {
    TextEditingController nameController = TextEditingController(text: name);

    TextEditingController emailController = TextEditingController(text: email);

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              TextField(
                controller: nameController,

                decoration: const InputDecoration(labelText: 'Name'),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: emailController,

                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  name = nameController.text;

                  email = emailController.text;
                });

                Navigator.pop(context);
              },

              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _changeProfilePicture() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Profile Picture'),

          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    profileIcon = Icons.person;
                  });

                  Navigator.pop(context);
                },

                icon: const Icon(Icons.person, size: 40),
              ),

              IconButton(
                onPressed: () {
                  setState(() {
                    profileIcon = Icons.face;
                  });

                  Navigator.pop(context);
                },

                icon: const Icon(Icons.face, size: 40),
              ),

              IconButton(
                onPressed: () {
                  setState(() {
                    profileIcon = Icons.account_circle;
                  });

                  Navigator.pop(context);
                },

                icon: const Icon(Icons.account_circle, size: 40),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;

  bool dailyReminder = true;

  bool darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1B1A),

        title: const Text('Settings', style: TextStyle(color: Colors.white)),

        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Column(
        children: [
          SwitchListTile(
            title: const Text(
              'Notifications',
              style: TextStyle(color: Colors.white),
            ),

            subtitle: const Text(
              'Receive app notifications',
              style: TextStyle(color: Colors.white70),
            ),

            value: notifications,

            onChanged: (value) {
              setState(() {
                notifications = value;
              });
            },
          ),

          SwitchListTile(
            title: const Text(
              'Daily Journal Reminder',
              style: TextStyle(color: Colors.white),
            ),

            subtitle: const Text(
              'Remember to write your journal',
              style: TextStyle(color: Colors.white70),
            ),

            value: dailyReminder,

            onChanged: (value) {
              setState(() {
                dailyReminder = value;
              });
            },
          ),

          SwitchListTile(
            title: const Text(
              'Dark Mode',
              style: TextStyle(color: Colors.white),
            ),

            value: darkMode,

            onChanged: (value) {
              setState(() {
                darkMode = value;
              });
            },
          ),

          ListTile(
            title: const Text(
              'About SprintJournal',
              style: TextStyle(color: Colors.white),
            ),

            onTap: () {
              showDialog(
                context: context,

                builder: (context) {
                  return AlertDialog(
                    title: const Text('SprintJournal'),

                    content: const Text(
                      'SprintJournal helps you record your daily thoughts, '
                      'track your progress and build better habits.',
                    ),

                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
