import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/question_model.dart';
import '../../services/question_service.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  QuestionBloc() : super(QuestionInitial()) {
    on<QuestionEvent>((event, emit) async {
      if (event is QuestionGet) {
        try {
          emit(QuestionLoading());

          final questions = await QuestionService().getQuestions();
          emit(QuestionSuccess(questions));
        } catch (e) {
          emit(QuestionFailed(e.toString()));
        }
      }
    });
  }
}
