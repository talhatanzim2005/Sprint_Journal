import 'package:flutter/material.dart';

class ProgressGraph extends StatelessWidget {
  const ProgressGraph({
    super.key,
    required this.isThirtyDays,
  });

  final bool isThirtyDays;

  static const Color cardColor = Color(0xFF252524);
  static const Color redColor = Color(0xFFCD0033);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      width: double.infinity,
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Column(
        children: [

          // ---------------- GRAPH TITLE ----------------

          const Align(
            alignment: Alignment.centerLeft,

            child: Text(
              'Completion %',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(height: 5),

          Expanded(
            child: Row(
              children: [

                // ---------------- Y AXIS ----------------

                const Column(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

                  children: [

                    Text(
                      '100%',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),

                    Text(
                      '75%',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),

                    Text(
                      '50%',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),

                    Text(
                      '25%',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),

                    Text(
                      '0%',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 10),

                // ---------------- GRAPH ----------------

                Expanded(
                  child: isThirtyDays
                      ? _thirtyDayGraph()
                      : _weekGraph(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // THIS WEEK GRAPH
  // ==============================================================

  Widget _weekGraph() {
    return Column(
      children: [

        Expanded(
          child: Stack(
            alignment: Alignment.bottomCenter,

            children: [

              // ---------------- GUIDE LINES ----------------

              Column(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [
                  graphLine(),
                  graphLine(),
                  graphLine(),
                  graphLine(),
                  graphLine(),
                ],
              ),

              // ---------------- BARS ----------------

              Row(
                crossAxisAlignment:
                CrossAxisAlignment.end,

                mainAxisAlignment:
                MainAxisAlignment.spaceAround,

                children: [
                  weekBar('Mon', 0.55),
                  weekBar('Tue', 0.75),
                  weekBar('Wed', 0.40),
                  weekBar('Thu', 0.90),
                  weekBar('Fri', 0.65),
                  weekBar('Sat', 0.80),
                  weekBar('Sun', 0.50),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // LAST 30 DAYS GRAPH
  // ==============================================================

  Widget _thirtyDayGraph() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      child: SizedBox(
        width: 1100,

        child: Column(
          children: [

            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,

                children: [

                  // ---------------- GUIDE LINES ----------------

                  Column(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [
                      graphLine(),
                      graphLine(),
                      graphLine(),
                      graphLine(),
                      graphLine(),
                    ],
                  ),

                  // ---------------- 30 BARS ----------------

                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.end,

                    children: [

                      dayBar('1', 0.50),
                      dayBar('2', 0.70),
                      dayBar('3', 0.30),
                      dayBar('4', 0.80),
                      dayBar('5', 0.60),
                      dayBar('6', 0.90),
                      dayBar('7', 0.50),
                      dayBar('8', 0.70),
                      dayBar('9', 0.40),
                      dayBar('10', 0.80),
                      dayBar('11', 0.60),
                      dayBar('12', 0.90),
                      dayBar('13', 0.50),
                      dayBar('14', 0.70),
                      dayBar('15', 0.80),
                      dayBar('16', 0.40),
                      dayBar('17', 0.60),
                      dayBar('18', 0.90),
                      dayBar('19', 0.70),
                      dayBar('20', 0.50),
                      dayBar('21', 0.80),
                      dayBar('22', 0.60),
                      dayBar('23', 0.90),
                      dayBar('24', 0.40),
                      dayBar('25', 0.70),
                      dayBar('26', 0.80),
                      dayBar('27', 0.50),
                      dayBar('28', 0.90),
                      dayBar('29', 0.60),
                      dayBar('30', 0.80),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // GRAPH GUIDE LINE
  // ==============================================================

  Widget graphLine() {
    return Container(
      height: 1,
      width: double.infinity,
      color: Colors.white24,
    );
  }

  // ==============================================================
  // 7 DAY BAR
  // ==============================================================

  Widget weekBar(
      String day,
      double height,
      ) {
    return SizedBox(
      width: 30,

      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.end,

        children: [

          Container(
            width: 22,
            height: 130 * height,

            decoration: BoxDecoration(
              color: redColor,
              borderRadius:
              BorderRadius.circular(6),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            day,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // 30 DAY BAR
  // ==============================================================

  Widget dayBar(
      String day,
      double height,
      ) {
    return SizedBox(
      width: 35,

      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.end,

        children: [

          Container(
            width: 22,
            height: 130 * height,

            decoration: BoxDecoration(
              color: redColor,
              borderRadius:
              BorderRadius.circular(6),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            day,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}