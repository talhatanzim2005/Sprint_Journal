import 'package:flutter/material.dart';

void showHabitsDialog(
    BuildContext context,
    List<String> habits,
    List<bool> habitDone,
    Function(int, bool) onChanged,
    ) {
  showDialog(
    context: context,

    builder: (dialogContext) {

      return AlertDialog(
        backgroundColor:
        const Color(0xFF252524),

        title: const Text(
          'My Habits',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        content: SizedBox(
          width: double.maxFinite,

          child: ListView.builder(
            shrinkWrap: true,

            itemCount: habits.length,

            itemBuilder: (context, index) {

              return CheckboxListTile(
                activeColor:
                const Color(0xFFCD0033),

                checkColor: Colors.white,

                value: habitDone[index],

                title: Text(
                  habits[index],
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),

                onChanged: (value) {

                  onChanged(
                    index,
                    value ?? false,
                  );

                  Navigator.pop(dialogContext);

                  showHabitsDialog(
                    context,
                    habits,
                    habitDone,
                    onChanged,
                  );
                },
              );
            },
          ),
        ),

        actions: [

          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },

            child: const Text(
              'Close',
              style: TextStyle(
                color: Color(0xFFCD0033),
              ),
            ),
          ),
        ],
      );
    },
  );
}