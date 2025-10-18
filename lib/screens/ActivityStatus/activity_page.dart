import 'package:flutter/material.dart';

import '../Settings/settings_1.dart';
import '../challenges.dart';
import '../exercise.dart';
import '../home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mhealthapp/db_helper.dart';
import 'package:fl_chart/fl_chart.dart';

DateTime _mondayOf(DateTime d) => d.subtract(Duration(days: d.weekday - 1));

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int _selectedTab = 0; // 0 = Exercise Log, 1 = Stats
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  List<Map<String, String>> _logs = [];
  bool _loading = true;
  String? _error;
  int? _userId;
  bool _inserting = false;
  ActivityStats? _stats;
  bool _statsLoading = true;
  bool _seedingDaily = false;
  int _chartsEpoch = 0;

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _userId = prefs.getInt('userId'));
  }

  Future<void> _loadWorkoutLogs() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      // 1) Fetch userId from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId == null) {
        setState(() {
          _loading = false;
          _error = 'No userId found — create/select a user first.';
        });
        return;
      }

      final rows = await DBHelper().getWorkoutLogs(userId);

      final mapped =
          rows.map<Map<String, String>>((r) {
            return {
              'exercise': (r['workout_name'] ?? '').toString(),
              'date': (r['workout_date'] ?? '').toString(),
              'time': (r['duration_min'] ?? '').toString(),
              'cal': (r['calories_burned'] ?? '').toString(),
            };
          }).toList();

      setState(() {
        _logs = mapped;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Failed to load workout logs: $e';
      });
    }
  }

  Future<void> _insertMockDataAndRefresh() async {
    if (_inserting) return;
    setState(() => _inserting = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              ' No userId found. Please create or select a user first.',
            ),
          ),
        );
        return;
      }

      final dbHelper = DBHelper();
      await dbHelper.insertMockWorkoutSessions(userId);

      await _loadWorkoutLogs();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mock workout sessions inserted successfully!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Insert failed: $e')));
    } finally {
      if (mounted) setState(() => _inserting = false);
    }
  }

  Future<void> _loadStats() async {
    setState(() => _statsLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) {
      if (!mounted) return;
      setState(() {
        _statsLoading = false;
        _stats = null;
      });
      return;
    }
    final now = DateTime.now();
    final s = await DBHelper().getDailyStats(userId: userId, day: now);
    if (!mounted) return;
    setState(() {
      _stats = s;
      _statsLoading = false;
    });
  }

  Future<void> _insertMockDailyAndRefresh() async {
    if (_seedingDaily) return;
    setState(() => _seedingDaily = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      if (userId == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No user selected.')));
        return;
      }

      await DBHelper().insertMockDailyData(userId);

      await _loadStats();

      await DBHelper().printTable("daily_activity_fact");

      if (!mounted) return;
      setState(() => _chartsEpoch++);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inserted 2 weeks of mock daily data.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Insert failed: $e')));
    } finally {
      if (mounted) setState(() => _seedingDaily = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _loadWorkoutLogs();
    _loadStats();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.emoji_events_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChallengesPage()),
                );
              },
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(width: 6),
                  Text("mHealth", style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.deepPurple),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: _selectedTab == 0 ? _buildExerciseLog() : _buildStats(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExercisePage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: 'Exercise',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Activity',
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseLog() {
    if (_loading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadWorkoutLogs,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final query = _searchQuery.trim().toLowerCase();
    final filteredLogs =
        _logs.where((log) {
          final name = (log['exercise'] ?? '').toLowerCase();
          return name.contains(query);
        }).toList();

    return Column(
      children: [
        // Toggle buttons
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(8),
              fillColor: Colors.deepPurple.shade100,
              selectedColor: Colors.deepPurple,
              isSelected: [_selectedTab == 0, _selectedTab == 1],
              onPressed: (i) => setState(() => _selectedTab = i),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Exercise Log"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Activity Statistics"),
                ),
              ],
            ),
          ),
        ),

        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search exercises...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(8),
            ),
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: ElevatedButton.icon(
            icon:
                _inserting
                    ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : const Icon(Icons.library_add),
            label: Text(_inserting ? 'Inserting...' : 'Insert Mock Data'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(44),
            ),
            onPressed: _inserting ? null : _insertMockDataAndRefresh,
          ),
        ),
        // Header row
        Container(
          color: Colors.deepPurple.shade50,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: const [
              Expanded(
                flex: 3,
                child: Text(
                  "Exercise",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Date",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Time",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Calories",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Table rows
        Expanded(
          child: ListView.separated(
            itemCount: filteredLogs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final log = filteredLogs[index];
              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: Text(log["exercise"]!)),
                    Expanded(flex: 2, child: Text(log["date"]!)),
                    Expanded(flex: 2, child: Text("${log["time"]} min")),
                    Expanded(flex: 2, child: Text("${log["cal"]} cal")),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // keep _buildStats, _showStandPopup, _buildActivityCard, _MetricTile same as before...
  Widget _buildStats() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toggle buttons at top
          Center(
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(8),
              fillColor: Colors.deepPurple.shade100,
              selectedColor: Colors.deepPurple,
              isSelected: [_selectedTab == 0, _selectedTab == 1],
              onPressed: (i) => setState(() => _selectedTab = i),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Exercise Log"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Activity Statistics"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Top bar with dropdown + Sort/Filter
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     DropdownButton<String>(
          //       value: "Steps",
          //       items:
          //           ["Steps", "Calories", "Stand"].map((value) {
          //             return DropdownMenuItem(value: value, child: Text(value));
          //           }).toList(),
          //       onChanged: (val) {},
          //     ),
          //     ElevatedButton(
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: Colors.deepPurple,
          //         foregroundColor: Colors.white,
          //         padding: const EdgeInsets.symmetric(
          //           horizontal: 12,
          //           vertical: 8,
          //         ),
          //       ),
          //       onPressed: () {},
          //       child: const Text("Sort/Filter"),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ElevatedButton.icon(
              onPressed: _seedingDaily ? null : _insertMockDailyAndRefresh,
              icon:
                  _seedingDaily
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : const Icon(Icons.library_add),
              label: Text(
                _seedingDaily
                    ? 'Seeding daily data...'
                    : 'Insert Mock Daily Data',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(44),
              ),
            ),
          ),

          // Line chart placeholder
          // SizedBox(
          //   height: 220,
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.horizontal,
          //     child: Row(
          //       children: List.generate(3, (i) {
          //         return Container(
          //           width: MediaQuery.of(context).size.width * 0.9,
          //           margin: const EdgeInsets.only(right: 16),
          //           decoration: BoxDecoration(
          //             border: Border.all(color: Colors.grey.shade300),
          //             borderRadius: BorderRadius.circular(8),
          //           ),
          //           child: const Placeholder(),
          //         );
          //       }),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 20),
          if (_userId != null) ...[
            SizedBox(
              height: 350,
              child: WeeklyChartsPager(
                key: ValueKey(_chartsEpoch),
                userId: _userId!,
              ),
            ),
            const SizedBox(height: 20),
          ] else ...[
            const SizedBox(
              height: 350,
              child: Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 20),
          ],
          // Daily Activity Summary
          const Text(
            "Daily Activity",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActivityCard(
                "Steps",
                _stats != null ? "${_stats!.steps}" : "–",
              ),
              _buildActivityCard(
                "Calories",
                _stats != null ? "${_stats!.calories}" : "–",
              ),
              // GestureDetector(
              //   onTap: () => _showStandPopup(context), // Popup trigger
              //   child: _buildActivityCard("Stand", "6/10"),
              // ),
            ],
          ),
          const SizedBox(height: 20),

          // Heart rate + Sleep
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _MetricTile(
                icon: Icons.favorite,
                label: _stats != null ? "${_stats!.avgBpm} bpm" : "–",
              ),
              _MetricTile(
                icon: Icons.bedtime,
                label:
                    (_stats != null
                        ? "${_stats!.sleepHours.toStringAsFixed(1)} hrs"
                        : "–"),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Sedentary vs Active bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: ((_stats?.sedentaryHours ?? 0) * 10).toInt(),
                    child: Container(
                      height: 20,
                      color: Colors.grey.shade400,
                      child: Center(
                        child: Text(
                          _stats != null
                              ? "${_stats!.sedentaryHours.toStringAsFixed(1)} hrs"
                              : "–",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: ((_stats?.activeHours ?? 0) * 10).toInt(),
                    child: Container(
                      height: 20,
                      color: Colors.deepPurple,
                      child: Center(
                        child: Text(
                          _stats != null
                              ? "${_stats!.activeHours.toStringAsFixed(1)} hrs"
                              : "–",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                "Sedentary                                                             Active",
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Popup for Stand
  void _showStandPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('What is "Stand"?'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Standing helps break up long periods of sitting and keeps your body active throughout the day. '
                  'This feature tracks how often you stand and move around, encouraging you to get up at least once every hour.\n',
                ),
                Text('Goal:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  'Stand and move for at least 1 minute each hour, across several hours of your day.\n',
                ),
                Text(
                  'Regular standing can help improve circulation, posture, and overall well-being!',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActivityCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetricTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 28),
        const SizedBox(height: 6),
        Text(label),
      ],
    );
  }
}

class WeeklyLineChart extends StatelessWidget {
  final List<DailyPoint> data;
  final String title;
  const WeeklyLineChart({super.key, required this.data, required this.title});

  @override
  Widget build(BuildContext context) {
    // x: 0..6, y: value
    final spots = List<FlSpot>.generate(
      7,
      (i) => FlSpot(i.toDouble(), data[i].value),
    );

    String dayLabel(int i) =>
        const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][i.clamp(0, 6)];

    final maxVal = data.fold<double>(0, (m, e) => e.value > m ? e.value : m);
    final yMax =
        (maxVal * 1.2).clamp(1, double.infinity).toDouble(); // <- double

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge, // don't draw outside the border
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: yMax,
                // keep chart inside border
                clipData: const FlClipData.all(),
                // light grid, horizontal only to reduce clutter
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: yMax / 4, // 4 bands
                ),
                borderData: FlBorderData(show: true),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32, // tighter than default
                      getTitlesWidget:
                          (v, meta) => Text(
                            v.round().toString(),
                            style: const TextStyle(fontSize: 10),
                          ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget:
                          (x, meta) => Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              dayLabel(x.round()),
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: false, // <- straight line
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                  ),
                ],
                // optional: nicer touch tooltip
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 6,
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WeeklyChartsPager extends StatefulWidget {
  final int userId;
  const WeeklyChartsPager({super.key, required this.userId});

  @override
  State<WeeklyChartsPager> createState() => _WeeklyChartsPagerState();
}

class _WeeklyChartsPagerState extends State<WeeklyChartsPager> {
  final _pageCtrl = PageController(initialPage: 0);
  int _page = 0; // 0 = this week, 1 = previous, etc.
  Metric _metric = Metric.steps;

  DateTime _weekStartForPage(int page) {
    final thisMonday = _mondayOf(DateTime.now());
    return thisMonday.subtract(Duration(days: 7 * page));
  }

  String _weekLabel(DateTime start) {
    final end = start.add(const Duration(days: 6));
    String fmt(DateTime d) => '${d.month}/${d.day}';
    return '< ${fmt(start)} - ${fmt(end)} >';
  }

  void _goOlder() {
    // left chevron: older weeks => page++
    _pageCtrl.nextPage(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  void _goNewer() {
    // right chevron: newer weeks => page-- ; stop at 0 (current week)
    if (_page == 0) return;
    _pageCtrl.previousPage(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top controls: metric dropdown + arrows
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton<Metric>(
              value: _metric,
              items: const [
                DropdownMenuItem(value: Metric.steps, child: Text('Steps')),
                DropdownMenuItem(
                  value: Metric.calories,
                  child: Text('Calories'),
                ),
              ],
              onChanged: (m) => setState(() => _metric = m!),
            ),
            Row(
              children: [
                // LEFT = older
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _goOlder,
                  tooltip: 'Previous week (older)',
                ),
                // RIGHT = newer (disabled at this week)
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _page == 0 ? null : _goNewer,
                  tooltip: 'Next week (newer)',
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),

        // PageView: each page = one week
        SizedBox(
          height: 260,
          child: PageView.builder(
            controller: _pageCtrl,
            onPageChanged: (p) => setState(() => _page = p), // track page
            itemBuilder: (context, page) {
              final weekStart = _weekStartForPage(page);
              return Column(
                children: [
                  Text(
                    _weekLabel(weekStart),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: FutureBuilder<List<DailyPoint>>(
                      future: DBHelper().getWeekActivity(
                        userId: widget.userId,
                        weekStart: weekStart,
                        metric: _metric,
                      ),
                      builder: (context, snap) {
                        if (snap.connectionState != ConnectionState.done) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snap.hasError) {
                          return Center(child: Text('Error: ${snap.error}'));
                        }
                        final data = snap.data ?? const <DailyPoint>[];
                        return WeeklyLineChart(
                          data: data,
                          title:
                              _metric == Metric.steps
                                  ? 'Steps / Day'
                                  : 'Calories / Day',
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
