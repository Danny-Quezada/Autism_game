import 'package:autism_test_drag_drop/appcore/services/autism_game_provider.dart';
import 'package:confetti/confetti.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_to_speech/text_to_speech.dart';

/// A custom Path to paint stars.
Path drawStar(Size size) {
  // Method to convert degree to radians
  double degToRad(double deg) => deg * (pi / 180.0);

  const numberOfPoints = 5;
  final halfWidth = size.width / 2;
  final externalRadius = halfWidth;
  final internalRadius = halfWidth / 2.5;
  final degreesPerStep = degToRad(360 / numberOfPoints);
  final halfDegreesPerStep = degreesPerStep / 2;
  final path = Path();
  final fullAngle = degToRad(360);
  path.moveTo(size.width, halfWidth);

  for (double step = 0; step < fullAngle; step += degreesPerStep) {
    path.lineTo(halfWidth + externalRadius * cos(step),
        halfWidth + externalRadius * sin(step));
    path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep));
  }
  path.close();
  return path;
}

class AutismPageGame extends StatelessWidget {
  AutismPageGame({super.key});

  @override
  Widget build(BuildContext context) {
    final autismGameProvider =
        Provider.of<AutismGameProvider>(context, listen: false);
    TextToSpeech tts = TextToSpeech();
    tts.setLanguage('es-ES');
    // tts.speak("Niña va a su casa de verano");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Game 🎮"),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(autismGameProvider.words[0].imageUrl),
              IconButton(
                  onPressed: () {
                    tts.speak("Niña va a su casa de verano");
                  },
                  icon: const Icon(Icons.volume_up)),
              SizedBox(
                height: 100,
                width: double.infinity,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: autismGameProvider.words[0].words.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10)),
                      child: DragTarget(onWillAccept: (data) {
                        return data ==
                            autismGameProvider.words[0].words[index].word;
                      }, onAccept: (data) {
                        autismGameProvider.changeWordCompleted(0, index);
                        tts.speak(
                            autismGameProvider.words[0].words[index].word);
                      }, builder: (context, candidateData, rejectedData) {
                        final topController = ConfettiController(
                            duration: const Duration(seconds: 2));
              
                        return Selector<AutismGameProvider, bool?>(
                            builder: (context, value, child) {
                              if (value == true) {
                                return ConfettiWidget(
                                  createParticlePath: drawStar,
                                  blastDirection: 2 * pi,
                                  confettiController: topController..play(),
                                  child: Image.asset(
                                    autismGameProvider
                                        .words[0].words[index].imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }
              
                              return Container();
                            },
                            selector: (_, provider) =>
                                provider.words[0].words[index].completed);
                      }),
                      width: 50,
                      height: 100,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 70,
                width: double.infinity,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: autismGameProvider.words[0].words.length,
                  itemBuilder: (context, index) {
                    return Selector<AutismGameProvider, bool?>(
                        builder: (context, value, child) {
                          if (value == null) {
                            return Container(
                              margin: EdgeInsets.all(20),
                              child: Draggable(
                                
                                  data: autismGameProvider
                                      .words[0].words[index].word,
                                  child: DottedBorder(
                                    stackFit: StackFit.passthrough,
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(autismGameProvider
                                        .words[0].words[index].word),
                                  ),
                                  childWhenDragging: DottedBorder(child: SizedBox(width: 50,), ),
                                  feedback: Image(
                                      height: 100,
                                      width: 100,
                                      image: AssetImage(autismGameProvider
                                          .words[0].words[index].imageUrl))),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        selector: (_, provider) =>
                            provider.words[0].words[index].completed);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
