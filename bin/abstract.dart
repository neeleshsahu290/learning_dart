// 1. Abstract Class
// 2. Abstract methods

void abstract(){

}


abstract class Shape{

  var x;

  void draw(); // this is a abstract method this must need to be override

  void normalFunction(){} // not compulsory to be override
}

class Rectangle extends Shape {

  @override
  void draw() {}

}


class Remote{

  void volumeUp(){
    print("this is a volume up button");
  }

  void volumeDown(){
    print("this is a volume down button");
  }

}

// implements keyword acting as a interface in dart a method needs to ne override compulsory
class Television implements Remote{
  @override
  void volumeDown() {
   // this method  super.volumeDown() is not allowed
  }

  @override
  void volumeUp() {
  }

}

