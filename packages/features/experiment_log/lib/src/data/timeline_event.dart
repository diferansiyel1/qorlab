class TimelineEvent {
  final String time;
  final String type; // 'note', 'dose', 'result'
  final String? title;
  final String? text;
  final String? value;

  TimelineEvent.note({required this.time, required this.text}) 
      : type = 'note', title = 'Note', value = null;
      
  TimelineEvent.dose({required this.time, required String drug, required String dose, required String route}) 
      : type = 'dose', title = 'Dose: $drug', text = '$dose ($route)', value = null;
      
  TimelineEvent.result({required this.time, required this.title, required this.value}) 
      : type = 'result', text = null;
  
  TimelineEvent.photo({required this.time, required this.title})
      : type = 'photo', text = 'Photo Reference', value = null;
}
