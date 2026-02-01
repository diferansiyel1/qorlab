class TimelineEvent {
  final String time;
  final String type; // 'note', 'dose', 'result', 'photo'
  final String? title;
  final String? text;
  final String? value;
  final String? photoPath;

  TimelineEvent.note({required this.time, required this.text}) 
      : type = 'note', title = 'Note', value = null, photoPath = null;
      
  TimelineEvent.dose({required this.time, required String drug, required String dose, required String route}) 
      : type = 'dose', title = 'Dose: $drug', text = '$dose ($route)', value = null, photoPath = null;
      
  TimelineEvent.result({required this.time, required this.title, required this.value}) 
      : type = 'result', text = null, photoPath = null;
  
  TimelineEvent.photo({required this.time, required this.photoPath})
      : type = 'photo', title = 'Photo', text = null, value = null;
}
