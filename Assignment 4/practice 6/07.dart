//Create a simple quiz application using oop that allows users to play and view their score.

import 'dart:io';


class Question {
  String ques;
  List<String> options;
  int correct_Ans;

  Question(this.ques, this.options, this.correct_Ans);

  bool isCorrect(int Choice) {
    return Choice == correct_Ans;
  }
}

class Quiz {
  List<Question> questions;
  int score = 0;

  Quiz(this.questions);

  void start() {
    print('Welcome to the Quiz Game!\n');
    for (int i = 0; i < questions.length; i++) {
      var q = questions[i];
      print('Question ${i + 1}: ${q.ques}');
      for (int j = 0; j < q.options.length; j++) {
        print('${j + 1}. ${q.options[j]}');
      }

      stdout.write('Enter your answer (1-${q.options.length}): ');
      String? input = stdin.readLineSync();
      int? answer = int.tryParse(input ?? '');

      if (answer != null && answer >= 1 && answer <= q.options.length) {
        if (q.isCorrect(answer - 1)) {
          print('Correct!\n');
          score++;
        } else {
          print('Wrong! Correct answer: ${q.options[q.correct_Ans]}\n');
        }
      } else {
        print('Invalid input! Skipping question.\n');
      }
    }

    print('Quiz finished!');
    print('Your final score: $score / ${questions.length}');
  }
}

void main() {
  List<Question> questionList = [
    Question('How many members are in BTS??', ['5', '7', '4', '9'], 1),
    Question('Who is the youngest in BTS?', ['Jungkook', 'V', 'Jimin', 'RM'], 0),
    Question('What is the real name of V?', ['Yunjin', 'kai', 'jay', 'Taehyung'], 3),
    Question('which is BTS song?', ['APT', 'Like that', 'Fake Love', 'Crazy'], 2),
    Question('Who is the leader of BTS?', ['Jungkook', 'V', 'RM', 'Jin'], 2),
    Question('Who in BTS perform in world cup?', ['Jungkook', 'V', 'RM', 'Jin'], 0),
    Question('Who is the dance machine in BTS?', ['Jungkook', 'V', 'Jhope', 'Jimin'], 2),
  ];

  Quiz quiz = Quiz(questionList);

  quiz.start();
}
