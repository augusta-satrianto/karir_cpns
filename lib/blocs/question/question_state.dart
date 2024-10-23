part of 'question_bloc.dart';

sealed class QuestionState extends Equatable {
  const QuestionState();

  @override
  List<Object> get props => [];
}

final class QuestionInitial extends QuestionState {}

final class QuestionLoading extends QuestionState {}

final class QuestionFailed extends QuestionState {
  final String e;
  const QuestionFailed(this.e);

  @override
  List<Object> get props => [e];
}

final class QuestionSuccess extends QuestionState {
  final List<QuestionModel> questions;
  const QuestionSuccess(this.questions);

  @override
  List<Object> get props => [questions];
}
