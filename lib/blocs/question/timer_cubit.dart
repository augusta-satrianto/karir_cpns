import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';

class TimerCubit extends Cubit<int> {
  Timer? _timer;
  int _remainingTime = 60;

  TimerCubit() : super(0); // State awal 0 detik

  Future<void> loadStartTime() async {
    final Box<int> timerBox = await Hive.openBox<int>('timer');
    final startTime = timerBox.get('startTime',
        defaultValue: DateTime.now().millisecondsSinceEpoch);
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    _remainingTime = 3600 - ((currentTime - startTime!) ~/ 1000);

    if (_remainingTime < 0) {
      _remainingTime = 0;
    }

    emit(_remainingTime); // Emit waktu yang benar setelah data diambil

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        emit(_remainingTime);
      } else {
        _timer?.cancel();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
