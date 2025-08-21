import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_architecture_flutter_firebase/src/constants/strings.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/data/habit_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/domain/habit.dart';
import 'package:starter_architecture_flutter_firebase/src/features/entries/data/entries_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/entries/domain/entry.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/app_router.dart';
import 'package:starter_architecture_flutter_firebase/src/localization/string_hardcoded.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart

class DashboardsScreen extends ConsumerWidget {
  const DashboardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Dashboard'.hardcoded),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weekly Progress',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: Consumer(
                          builder: (context, ref, child) {
                            return _buildWeeklyChart(ref);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, child) {
                final habitQuery = ref.watch(habitsQueryProvider);
                return FirestoreQueryBuilder<Habit>(
                  query: habitQuery,
                  builder: (context, snapshot, child) {
                    if (snapshot.isFetching) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.docs.isEmpty) {
                      return Center(
                        child: Text(
                          'No habits found.'.hardcoded,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      shrinkWrap:
                          true, // Allows the GridView to be inside a SingleChildScrollView
                      physics:
                          const NeverScrollableScrollPhysics(), // Prevents nested scrolling
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: snapshot.docs.length,
                      itemBuilder: (context, index) {
                        final habit = snapshot.docs[index].data();
                        return HabitDashboardCard(
                          habit: habit,
                          onTap: () => context.goNamed(
                            AppRoute.habit.name,
                            pathParameters: {'id': habit.id},
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(WidgetRef ref) {
    final user = ref.watch(firebaseAuthProvider).currentUser;
    if (user == null) {
      return const Center(child: Text('User not authenticated'));
    }

    final entriesRepository = ref.watch(entriesRepositoryProvider);
    return StreamBuilder<List<Entry>>(
      stream: entriesRepository.watchEntries(uid: user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final entries = snapshot.data ?? [];
        return BarChart(
          _buildBarChartDataFromEntries(entries),
          swapAnimationDuration: const Duration(milliseconds: 150),
          swapAnimationCurve: Curves.linear,
        );
      },
    );
  }

  // Helper function to build the BarChart data from real entries
  BarChartData _buildBarChartDataFromEntries(List<Entry> entries) {
    final now = DateTime.now();
    // Get the start of the current week (Monday)
    final weekStart = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));

    // Create a map to count entries per day
    final dailyEntries = <int, int>{};

    // Initialize all days of the week with 0
    for (int i = 0; i < 7; i++) {
      dailyEntries[i] = 0;
    }

    // Count entries for each day of the current week
    for (final entry in entries) {
      try {
        final entryDate =
            DateTime(entry.start.year, entry.start.month, entry.start.day);
        final daysDifference = entryDate.difference(weekStart).inDays;

        // Only count entries from the current week
        if (daysDifference >= 0 && daysDifference < 7) {
          dailyEntries[daysDifference] = (dailyEntries[daysDifference]! + 1);
        }
      } catch (e) {
        // Skip entries with invalid dates
        continue;
      }
    }

    final data = dailyEntries.entries
        .map((entry) => _makeBarData(entry.key, entry.value.toDouble()))
        .toList();

    // Calculate max value for better chart scaling
    final maxValue = dailyEntries.values.isEmpty
        ? 5.0
        : (dailyEntries.values.reduce((a, b) => a > b ? a : b).toDouble() + 1)
            .clamp(5.0, double.infinity);

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxValue,
      barGroups: data,
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
              return SideTitleWidget(
                meta: meta,
                space: 4,
                child: Text(
                  days[value.toInt()],
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                meta: meta,
                child: Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: true, drawVerticalLine: false),
    );
  }

  BarChartGroupData _makeBarData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: y > 0 ? Colors.blue : Colors.grey[300]!,
          width: 16,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

class HabitDashboardCard extends StatelessWidget {
  const HabitDashboardCard({
    super.key,
    required this.habit,
    this.onTap,
  });
  final Habit habit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = habit.color != null ? Color(habit.color!) : Colors.grey;
    final streak = habit.streak ?? 0;
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (streak > 0)
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department,
                            color: Colors.orange, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '$streak',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                habit.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'Goal: ${habit.dailyGoal} min',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
