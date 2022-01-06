mixin Converter{
  static String toMyTime(int seconds){
    final int hours = (seconds / 3600).floor();
    final int minutes = ((seconds - hours*3600) / 60).floor();
    final int secondsLeft = seconds - hours*3600 - minutes*60;
    if(hours == 0){
      return "$minutes Min & $secondsLeft Sec";
    }
    else{
      return "$hours Hrs & $minutes Min";
    }
  }
}