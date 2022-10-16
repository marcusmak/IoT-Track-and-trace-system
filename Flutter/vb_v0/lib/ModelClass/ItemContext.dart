import 'package:meta/meta.dart';
class ItemContext {
  final int create_time;
  int start_timestamp = null;
  String start_time = null;
  String start_date = null;
  int start_weekday = null;
  String frequency = null;
  String to_loc = null;
  String from_loc = null;

  ItemContext({this.start_timestamp,this.start_time,this.start_date,this.start_weekday, this.frequency, this.from_loc, this.to_loc}):create_time = DateTime.now().millisecondsSinceEpoch;

  Map<String,dynamic> toMap(){
    var results = Map<String,dynamic>(); 
    results.putIfAbsent("create_time", () => create_time);
    results.putIfAbsent("start_timestamp", () => start_timestamp);
    results.putIfAbsent("start_time", () => start_time);
    results.putIfAbsent("start_date", () => start_date);
    results.putIfAbsent("start_weekday", () => start_weekday);
    results.putIfAbsent("frequency", () => frequency);
    results.putIfAbsent("from_loc", () => from_loc);
    results.putIfAbsent("to_loc", () => to_loc);
    return results;
  }
}

class Location{
  String name;
  
  Location({@required this.name});

  @override
  String toString() {
    return this.name;
  }
}