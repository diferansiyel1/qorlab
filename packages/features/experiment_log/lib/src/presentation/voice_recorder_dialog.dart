import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class VoiceRecorderDialog extends StatefulWidget {
  const VoiceRecorderDialog({super.key});

  @override
  State<VoiceRecorderDialog> createState() => _VoiceRecorderDialogState();
}

class _VoiceRecorderDialogState extends State<VoiceRecorderDialog> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  void _initSpeech() async {
    // Request permission first
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
       setState(() {
         _text = "Microphone permission denied.";
       });
       return;
    }

    bool available = await _speech.initialize(
      onStatus: (val) {
        if (mounted) {
           print('onStatus: $val');
           if (val == 'done' || val == 'notListening') {
             setState(() => _isListening = false);
           }
        }
      },
      onError: (val) {
        if (mounted) {
           print('onError: $val');
           setState(() => _isListening = false);
        }
      },
    );

    if (available) {
      // Auto-start listening on open
      _listen();
    } else {
      if (mounted) {
        setState(() => _text = "Speech recognition not available on this device.");
      }
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Voice Entry'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isListening ? Colors.red.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _isListening ? Colors.red : Colors.grey),
            ),
            child: Text(
              _text,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          Text("Confidence: ${(_confidence * 100).toStringAsFixed(1)}%"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _speech.stop();
            Navigator.of(context).pop(); // Cancel
          },
          child: const Text('CANCEL'),
        ),
        FloatingActionButton(
          onPressed: _listen,
          backgroundColor: _isListening ? Colors.red : Colors.teal,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
        TextButton(
          onPressed: _text.isNotEmpty && _text != 'Press the button and start speaking' 
              ? () {
                  _speech.stop();
                  Navigator.of(context).pop(_text);
                } 
              : null,
          child: const Text('SAVE'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
}
