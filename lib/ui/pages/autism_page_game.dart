import 'package:autism_test_drag_drop/appcore/services/autism_game_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_to_speech/text_to_speech.dart';

class AutismPageGame extends StatelessWidget {
  AutismPageGame({super.key});

  @override
  Widget build(BuildContext context) {
    final autismGameProvider =
        Provider.of<AutismGameProvider>(context, listen: false);
    TextToSpeech tts = TextToSpeech();
    tts.setLanguage('es-ES');
    tts.speak("Niña va a su casa de verano");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Game 🎮"),
      ),
      body: Center(
        child: SingleChildScrollView(
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
                Center(
                  child: SizedBox(
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
                            print(data);
                            print(autismGameProvider.words[0].words[index].word);
                            return data ==
                                autismGameProvider.words[0].words[index].word;
                          }, onAccept: (data) {
                            autismGameProvider.changeWordCompleted(0, index);
                            tts.speak(autismGameProvider.words[0].words[index].word);
                          }, builder: (context, candidateData, rejectedData) {
                            return Selector<AutismGameProvider, bool>(
                                builder: (context, value, child) {
                                  if (value) {
                                    return Image.asset(autismGameProvider
                                        .words[0].words[index].imageUrl, fit: BoxFit.cover,);
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
                ),
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: autismGameProvider.words[0].words.length,
                    itemBuilder: (context, index) {
                      return Draggable(
                         data: autismGameProvider.words[0].words[index].word,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                autismGameProvider.words[0].words[index].word),
                          ),
                          feedback: Image(
                            height: 100,
                            width: 100,
                              image: AssetImage(autismGameProvider
                                  .words[0].words[index].imageUrl)));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
