import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:karir_cpns_app/blocs/question/timer_cubit.dart';
import 'blocs/question/question_bloc.dart';
import 'dart:async';

class DoExamPage extends StatefulWidget {
  final String level;
  final String examId;

  const DoExamPage({
    super.key,
    required this.level,
    required this.examId,
  });

  @override
  State<DoExamPage> createState() => _DoExamPageState();
}

class _DoExamPageState extends State<DoExamPage> {
  int selectedQuestion = 0;
  late Box<String> answersBox; // Box Hive untuk menyimpan jawaban
  late Box<bool> marksBox; // Box Hive untuk menyimpan mark soal
  final Map<int, String?> answers = {}; // Menyimpan jawaban per soal
  final Map<int, bool> marks = {}; // Menyimpan status mark per soal
  late Timer timer;
  late int remainingTime; // Countdown waktu tersisa dalam detik

  @override
  void initState() {
    super.initState();
    _initializeHive(); // Membuka Hive box dan memuat jawaban
  }

  Future<void> _initializeHive() async {
    answersBox = await Hive.openBox<String>('answers');
    marksBox = await Hive.openBox<bool>('marks'); // Membuka box untuk mark
    _loadAnswers(); // Memuat jawaban yang telah disimpan dari Hive
    _loadMarks(); // Memuat status mark dari Hive
  }

  void _loadAnswers() {
    for (int i = 0; i < 10; i++) {
      // Misalkan ada 10 soal
      answers[i] = answersBox.get(i.toString(),
          defaultValue: null); // Mengambil jawaban dari Hive
    }
  }

  void _loadMarks() {
    for (int i = 0; i < 10; i++) {
      marks[i] = marksBox.get(i.toString(),
          defaultValue: false)!; // Mengambil status mark dari Hive
    }
  }

  void _saveAnswer(int questionIndex, String? answer) {
    answersBox.put(
        questionIndex.toString(), answer!); // Menyimpan jawaban ke Hive
  }

  void _toggleMark(int questionIndex) {
    setState(() {
      bool isMarked = marks[questionIndex] ?? false;
      marks[questionIndex] = !isMarked; // Mengubah status mark
      marksBox.put(
          questionIndex.toString(), !isMarked); // Simpan status mark ke Hive
    });
  }

  @override
  void dispose() {
    answersBox.close(); // Menutup box Hive saat widget dihapus
    marksBox.close(); // Menutup box Hive untuk mark
    timer.cancel(); // Menghentikan timer saat halaman ditutup
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60) % 60;
    final hours = (seconds ~/ 3600);
    final remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    double bodyWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => QuestionBloc()..add(QuestionGet()),
      child: BlocBuilder<QuestionBloc, QuestionState>(
        builder: (context, state) {
          if (state is QuestionSuccess) {
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      width: 100,
                    ),
                  ],
                ),
                backgroundColor: Colors.white,
                shadowColor: Colors.white,
                surfaceTintColor: Colors.white,
                elevation: 2,
              ),
              body: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFFF2F4F9),
                        ),
                        borderRadius: BorderRadius.circular(4)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              bodyWidth > 500
                                  ? '(Silver) SKD CPNS-1 Tryout'
                                  : '(Silver)\nSKD CPNS-1\nTryout',
                              style: TextStyle(
                                  fontSize: bodyWidth > 500 ? 22 : 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            BlocProvider(
                              create: (context) {
                                final timerCubit = TimerCubit();
                                timerCubit.loadStartTime();
                                return timerCubit;
                              },
                              child: BlocBuilder<TimerCubit, int>(
                                builder: (context, remainingTime2) {
                                  return Text(_formatTime(remainingTime2),
                                      style: TextStyle(
                                          fontSize: bodyWidth > 850 ? 22 : 16,
                                          fontWeight: FontWeight.bold));
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          color: Color(0xFFE5E5E5),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color(0xFFF2F4F9),
                                    ),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'TWK - Question ${selectedQuestion + 1}',
                                          style: TextStyle(
                                              fontSize:
                                                  bodyWidth > 850 ? 20 : 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const Spacer(),
                                        if (bodyWidth > 500)
                                          buildMarkReportButton(bodyWidth)
                                      ],
                                    ),
                                    if (bodyWidth <= 500)
                                      buildMarkReportButton(bodyWidth),
                                    const Divider(
                                      color: Color(0xFFE5E5E5),
                                    ),
                                    Text(
                                      state.questions[selectedQuestion]
                                          .questionText!,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Column(
                                      children: List.generate(
                                        state.questions[selectedQuestion]
                                            .options!.length,
                                        (index) {
                                          // Daftar awalan huruf A, B, C, D, E
                                          const List<String> optionLetters = [
                                            'A',
                                            'B',
                                            'C',
                                            'D',
                                            'E'
                                          ];

                                          return RadioListTile<String>(
                                            title: Text(
                                              '${optionLetters[index]}. ${state.questions[selectedQuestion].options![index]}',
                                            ),
                                            value: state
                                                .questions[selectedQuestion]
                                                .options![index],
                                            groupValue:
                                                answers[selectedQuestion],
                                            onChanged: (value) {
                                              setState(() {
                                                answers[selectedQuestion] =
                                                    value;
                                                _saveAnswer(
                                                    selectedQuestion, value);
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: selectedQuestion > 0
                                              ? () {
                                                  setState(() {
                                                    selectedQuestion--;
                                                  });
                                                }
                                              : null,
                                          style: ButtonStyle(
                                            padding: WidgetStateProperty.all<
                                                EdgeInsets>(
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 10.0),
                                            ),
                                            backgroundColor: WidgetStateProperty
                                                .resolveWith<Color>(
                                              (Set<WidgetState> states) {
                                                if (states.contains(
                                                    WidgetState.hovered)) {
                                                  return const Color(
                                                      0xFFFFC1D1);
                                                }
                                                return const Color(0xFFFFD6E0);
                                              },
                                            ),
                                            elevation:
                                                WidgetStateProperty.all<double>(
                                                    0),
                                            shape: WidgetStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.arrow_back_outlined,
                                                  weight: 6,
                                                  color: Color(0xFFFF3366)),
                                              SizedBox(width: 8),
                                              Text('Previous',
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xFFFF3366))),
                                            ],
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: selectedQuestion <
                                                  state.questions.length - 1
                                              ? () {
                                                  setState(() {
                                                    selectedQuestion++;
                                                  });
                                                }
                                              : null,
                                          style: ButtonStyle(
                                            padding: WidgetStateProperty.all<
                                                EdgeInsets>(
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 10.0),
                                            ),
                                            backgroundColor: WidgetStateProperty
                                                .resolveWith<Color>(
                                              (Set<WidgetState> states) {
                                                if (states.contains(
                                                    WidgetState.hovered)) {
                                                  return const Color(
                                                      0xFFBAD5EB);
                                                }
                                                return const Color(0xFFD2E3F2);
                                              },
                                            ),
                                            elevation:
                                                WidgetStateProperty.all<double>(
                                                    0),
                                            shape: WidgetStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('Next',
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xFF0067B9))),
                                              SizedBox(width: 8),
                                              Icon(Icons.arrow_forward_outlined,
                                                  weight: 6,
                                                  color: Color(0xFF0067B9)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (bodyWidth > 850)
                              const SizedBox(
                                width: 20,
                              ),
                            if (bodyWidth > 850)
                              buildQuestionButtonGrid(
                                  state.questions.length, bodyWidth)
                          ],
                        ),
                        if (bodyWidth <= 850)
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: buildQuestionButtonGrid(
                                state.questions.length, bodyWidth),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Scaffold();
        },
      ),
    );
  }

  Widget buildMarkReportButton(double bodyWidth) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            _toggleMark(selectedQuestion);
          },
          style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsets>(
              bodyWidth > 850
                  ? const EdgeInsets.symmetric(horizontal: 10, vertical: 12)
                  : const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            ),
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.hovered)) {
                  return const Color(0xFF677389);
                }
                return const Color(0xFF7987A1);
              },
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            elevation: WidgetStateProperty.all<double>(0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.label_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text(marks[selectedQuestion] ?? false ? 'Unmark' : 'Mark Todo',
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsets>(
              bodyWidth > 850
                  ? const EdgeInsets.symmetric(horizontal: 10, vertical: 12)
                  : const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            ),
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.hovered)) {
                  return const Color(0xFFD92B57);
                }
                return const Color(0xFFFF3366);
              },
            ),
            elevation: WidgetStateProperty.all<double>(0),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.report, color: Colors.white),
              const SizedBox(width: 8),
              Text(bodyWidth > 850 ? 'Laporkan Soal' : 'Laporkan',
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        )
      ],
    );
  }

  Widget buildQuestionButtonGrid(int lengthButton, double bodyWidth) {
    return Container(
      width: bodyWidth > 850 ? 240 : double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFFF2F4F9),
          ),
          borderRadius: BorderRadius.circular(4)),
      child: Wrap(
        spacing: 15,
        runSpacing: 8.0,
        children: List.generate(lengthButton, (index) {
          return OutlinedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return selectedQuestion == index
                        ? const Color(0xFFFBBC06)
                        : answers[index] != null
                            ? const Color(0xFF1478C3)
                            : marks[index] ?? false
                                ? const Color(0xFF7987A1)
                                : const Color(0xFF1478C3);
                  }
                  return selectedQuestion == index
                      ? const Color(0xFFFBBC06)
                      : answers[index] != null
                          ? const Color(0xFF1478C3)
                          : marks[index] ?? false
                              ? const Color(0xFF7987A1)
                              : Colors.white;
                },
              ),
              foregroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return selectedQuestion == index
                        ? Colors.black
                        : answers[index] != null
                            ? Colors.white
                            : Colors
                                .white; // Ubah teks menjadi putih saat di-hover
                  }
                  return selectedQuestion == index
                      ? Colors.black
                      : answers[index] != null
                          ? Colors.white
                          : marks[index] ?? false
                              ? Colors.white
                              : const Color(
                                  0xFF0067B9); // Teks putih untuk soal terjawab, hitam untuk yang tidak terjawab
                },
              ),
              padding: WidgetStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
              ),
              side: WidgetStateProperty.all(BorderSide(
                  color: selectedQuestion == index
                      ? const Color(0xFFFBBC06)
                      : answers[index] != null
                          ? const Color(0xFF1478C3)
                          : marks[index] ?? false
                              ? const Color(0xFF7987A1)
                              : const Color(0xFF0067B9),
                  width: 0.8,
                  style: BorderStyle.solid)),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            onPressed: () {
              setState(() {
                selectedQuestion = index;
              });
            },
            child: Text(
              '${index + 1}',
            ),
          );
        }),
      ),
    );
  }
}
