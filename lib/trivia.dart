import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:ui';
import 'widgets/backgrounds/themed_background.dart';
import 'src/localization/app_localizations.dart';

class TriviaPage extends StatefulWidget {
  const TriviaPage({super.key});

  @override
  _TriviaPageState createState() => _TriviaPageState();
}

class _TriviaPageState extends State<TriviaPage> {
  late List<Map<String, Object>> _questions;
  bool _questionsInitialized = false;

  int _currentQuestionIndex = 0;
  int _score = 0;
  String _selectedAnswer = '';
  String _feedbackMessage = '';
  Color _feedbackColor = Colors.black;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_questionsInitialized) {
      _questions = _buildQuestions(context);
      _questionsInitialized = true;
    }
  }

  List<Map<String, Object>> _buildQuestions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      {
        'question': l10n.triviaQ1Question,
        'options': [
          l10n.triviaQ1Option1,
          l10n.triviaQ1Option2,
          l10n.triviaQ1Option3,
          l10n.triviaQ1Option4
        ],
        'answer': l10n.triviaQ1Answer,
        'hint': l10n.triviaQ1Hint,
      },
      {
        'question': l10n.triviaQ2Question,
        'options': [
          l10n.triviaQ2Option1,
          l10n.triviaQ2Option2,
          l10n.triviaQ2Option3,
          l10n.triviaQ2Option4
        ],
        'answer': l10n.triviaQ2Answer,
        'hint': l10n.triviaQ2Hint,
      },
      {
        'question': l10n.triviaQ1Question,
        'options': [
          l10n.triviaQ1Option1,
          l10n.triviaQ1Option2,
          l10n.triviaQ1Option3,
          l10n.triviaQ1Option4
        ],
        'answer': l10n.triviaQ1Answer,
        'hint': l10n.triviaQ1Hint,
      },
      {
        'question': l10n.triviaQ2Question,
        'options': [
          l10n.triviaQ2Option1,
          l10n.triviaQ2Option2,
          l10n.triviaQ2Option3,
          l10n.triviaQ2Option4
        ],
        'answer': l10n.triviaQ2Answer,
        'hint': l10n.triviaQ2Hint,
      },
      {
        'question': l10n.triviaQ3Question,
        'options': [
          l10n.triviaQ3Option1,
          l10n.triviaQ3Option2,
          l10n.triviaQ3Option3,
          l10n.triviaQ3Option4
        ],
        'answer': l10n.triviaQ3Answer,
        'hint': l10n.triviaQ3Hint,
      },
      {
        'question': l10n.triviaQ4Question,
        'options': [
          l10n.triviaQ4Option1,
          l10n.triviaQ4Option2,
          l10n.triviaQ4Option3,
          l10n.triviaQ4Option4
        ],
        'answer': l10n.triviaQ4Answer,
        'hint': l10n.triviaQ4Hint,
      },
      {
        'question': l10n.triviaQ5Question,
        'options': [
          l10n.triviaQ5Option1,
          l10n.triviaQ5Option2,
          l10n.triviaQ5Option3,
          l10n.triviaQ5Option4
        ],
        'answer': l10n.triviaQ5Answer,
        'hint': l10n.triviaQ5Hint,
      },
      {
        'question': l10n.triviaQ6Question,
        'options': [
          l10n.triviaQ6Option1,
          l10n.triviaQ6Option2,
          l10n.triviaQ6Option3,
          l10n.triviaQ6Option4
        ],
        'answer': l10n.triviaQ6Answer,
        'hint': l10n.triviaQ6Hint,
      },
      {
        'question': l10n.triviaQ7Question,
        'options': [
          l10n.triviaQ7Option1,
          l10n.triviaQ7Option2,
          l10n.triviaQ7Option3,
          l10n.triviaQ7Option4
        ],
        'answer': l10n.triviaQ7Answer,
        'hint': l10n.triviaQ7Hint,
      },
      {
        'question': l10n.triviaQ8Question,
        'options': [
          l10n.triviaQ8Option1,
          l10n.triviaQ8Option2,
          l10n.triviaQ8Option3,
          l10n.triviaQ8Option4
        ],
        'answer': l10n.triviaQ8Answer,
        'hint': l10n.triviaQ8Hint,
      },
      {
        'question': l10n.triviaQ9Question,
        'options': [
          l10n.triviaQ9Option1,
          l10n.triviaQ9Option2,
          l10n.triviaQ9Option3,
          l10n.triviaQ9Option4
        ],
        'answer': l10n.triviaQ9Answer,
        'hint': l10n.triviaQ9Hint,
      },
      {
        'question': l10n.triviaQ10Question,
        'options': [
          l10n.triviaQ10Option1,
          l10n.triviaQ10Option2,
          l10n.triviaQ10Option3,
          l10n.triviaQ10Option4
        ],
        'answer': l10n.triviaQ10Answer,
        'hint': l10n.triviaQ10Hint,
      },
      {
        'question': l10n.triviaQ11Question,
        'options': [
          l10n.triviaQ11Option1,
          l10n.triviaQ11Option2,
          l10n.triviaQ11Option3,
          l10n.triviaQ11Option4
        ],
        'answer': l10n.triviaQ11Answer,
        'hint': l10n.triviaQ11Hint,
      },
      {
        'question': l10n.triviaQ12Question,
        'options': [
          l10n.triviaQ12Option1,
          l10n.triviaQ12Option2,
          l10n.triviaQ12Option3,
          l10n.triviaQ12Option4
        ],
        'answer': l10n.triviaQ12Answer,
        'hint': l10n.triviaQ12Hint,
      },
      {
        'question': l10n.triviaQ13Question,
        'options': [
          l10n.triviaQ13Option1,
          l10n.triviaQ13Option2,
          l10n.triviaQ13Option3,
          l10n.triviaQ13Option4
        ],
        'answer': l10n.triviaQ13Answer,
        'hint': l10n.triviaQ13Hint,
      },
      {
        'question': l10n.triviaQ14Question,
        'options': [
          l10n.triviaQ14Option1,
          l10n.triviaQ14Option2,
          l10n.triviaQ14Option3,
          l10n.triviaQ14Option4
        ],
        'answer': l10n.triviaQ14Answer,
        'hint': l10n.triviaQ14Hint,
      },
      {
        'question': l10n.triviaQ15Question,
        'options': [
          l10n.triviaQ15Option1,
          l10n.triviaQ15Option2,
          l10n.triviaQ15Option3,
          l10n.triviaQ15Option4
        ],
        'answer': l10n.triviaQ15Answer,
        'hint': l10n.triviaQ15Hint,
      },
    ];
  }

  void _submitAnswer(String answer) {
    setState(() {
      if (answer == _questions[_currentQuestionIndex]['answer']) {
        _score++;
        _feedbackMessage = AppLocalizations.of(context)!.triviaCorrect;
        _feedbackColor = Colors.green;
      } else {
        _feedbackMessage = AppLocalizations.of(context)!.triviaWrongAnswer(
            _questions[_currentQuestionIndex]['answer'] as String);
        _feedbackColor = Colors.red;
      }
      _currentQuestionIndex++;
      _selectedAnswer = '';
    });
  }

  void _showHint(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.triviaHintDialogTitle),
          titleTextStyle: const TextStyle(color: Colors.white),
          content: Text(_questions[_currentQuestionIndex]['hint'] as String),
          contentTextStyle: const TextStyle(color: Colors.white),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.triviaAppBarTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ThemedBackground(
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _currentQuestionIndex < _questions.length
                  ? _buildQuestion()
                  : _buildResult(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion() {
    var currentQuestion = _questions[_currentQuestionIndex];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          currentQuestion['question'] as String,
          style: const TextStyle(fontSize: 24, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ...(currentQuestion['options'] as List<String>).map((option) {
          return ListTile(
            title: Text(option, style: const TextStyle(color: Colors.white)),
            leading: Radio<String>(
              value: option,
              groupValue: _selectedAnswer,
              onChanged: (value) {
                setState(() {
                  _selectedAnswer = value!;
                });
              },
            ),
          );
        }),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _selectedAnswer.isEmpty
              ? null
              : () => _submitAnswer(_selectedAnswer),
          child: Text(AppLocalizations.of(context)!.triviaSubmitAnswer),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _showHint(context),
          child: Text(AppLocalizations.of(context)!.triviaShowHint),
        ),
        const SizedBox(height: 20),
        Text(
          _feedbackMessage,
          style: TextStyle(fontSize: 18, color: _feedbackColor),
        ),
      ],
    );
  }

  Widget _buildResult() {
    double correctPercentage =
        _questions.isNotEmpty ? (_score / _questions.length) * 100 : 0;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            radius: 150.0,
            lineWidth: 13.0,
            percent: correctPercentage / 100,
            center: Text(
              AppLocalizations.of(context)!
                  .triviaScoreDisplay(_score, _questions.length),
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            backgroundColor: Colors.grey[300]!,
            progressColor: Colors.green,
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animationDuration: 1000,
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!
                .triviaScoreResult(_score, _questions.length),
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentQuestionIndex = 0;
                _score = 0;
                _selectedAnswer = '';
                _feedbackMessage = '';
                _feedbackColor = Colors.black;
              });
            },
            child: Text(AppLocalizations.of(context)!.triviaRestartQuiz),
          ),
        ],
      ),
    );
  }
}
