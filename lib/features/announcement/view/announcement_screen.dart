import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnnounceScreen extends ConsumerStatefulWidget {
  const AnnounceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnnounceScreenState();
}

class _AnnounceScreenState extends ConsumerState<AnnounceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Announcement")),
    );
  }
}
