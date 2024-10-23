import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class PrepareExamPage extends StatelessWidget {
  final String level;
  final String examId;

  const PrepareExamPage({
    super.key,
    required this.level,
    required this.examId,
  });

  Future<void> _saveStartTime() async {
    final Box<int> timerBox =
        await Hive.openBox<int>('timer'); // Membuka box timer
    timerBox.put('startTime',
        DateTime.now().millisecondsSinceEpoch); // Menyimpan waktu mulai
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prepare Page'),
      ),
      body: Column(
        children: [
          Text('Level: $level'),
          Text('Exam ID: $examId'),
          ElevatedButton(
            onPressed: () async {
              await _saveStartTime(); // Menyimpan waktu mulai saat tombol ditekan
              context.go(
                  '/dashboard/user/tryout/do-exam/skd-cpns/silver/skd-cpns-1');
            },
            child: Text('KERJAKAN'),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
