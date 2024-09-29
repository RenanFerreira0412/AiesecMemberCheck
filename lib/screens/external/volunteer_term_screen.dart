import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VolunteerTermScreen extends StatefulWidget {
  const VolunteerTermScreen({super.key});

  @override
  State<VolunteerTermScreen> createState() => _VolunteerTermScreenState();
}

class _VolunteerTermScreenState extends State<VolunteerTermScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => context.go('/authentication'),
              icon: const Icon(Icons.admin_panel_settings_rounded))
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
