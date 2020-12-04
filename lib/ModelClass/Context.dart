import 'package:meta/meta.dart';
class Context {

}

class Location{
  String name;
  
  Location({@required this.name});

  @override
  String toString() {
    return this.name;
  }
}