bool isSameDay(DateTime one, DateTime two){
  if(one.year == two.year && one.month == two.month && one.day == two.day){
    return true;
  }
  return false;
}