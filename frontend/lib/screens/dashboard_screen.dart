import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_frontend/widgets/dashboard/system_info_card.dart';
import 'package:mynas_frontend/widgets/dashboard/storage_overview_card.dart';
import 'package:mynas_frontend/widgets/dashboard/alerts_card.dart';
import 'package:mynas_frontend/widgets/dashboard/quick_actions_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 1200) {
              return _WideLayout();
            } else if (constraints.maxWidth > 800) {
              return _MediumLayout();
            } else {
              return _NarrowLayout();
            }
          },
        ),
      ),
    );
  }
}

class _WideLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: SystemInfoCard(),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: StorageOverviewCard(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: AlertsCard(),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: QuickActionsCard(),
            ),
          ],
        ),
      ],
    );
  }
}

class _MediumLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SystemInfoCard(),
        SizedBox(height: 16),
        StorageOverviewCard(),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: AlertsCard()),
            SizedBox(width: 16),
            Expanded(child: QuickActionsCard()),
          ],
        ),
      ],
    );
  }
}

class _NarrowLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          SystemInfoCard(),
          SizedBox(height: 16),
          StorageOverviewCard(),
          SizedBox(height: 16),
          AlertsCard(),
          SizedBox(height: 16),
          QuickActionsCard(),
        ],
      ),
    );
  }
}