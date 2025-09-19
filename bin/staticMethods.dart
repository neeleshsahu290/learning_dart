//Objectives
//Static method and variable
// you cannot access the static variable by creating objects
void staticMethods(){
  var circle=Circle();
  circle.ni;    // 4 bytes


  var circle2=Circle();
  circle2.ni;    // 4 bytes

  Circle.pi; // 4 bytes
  Circle.pi; // No memory allocated
  Circle.calculator();


}

class Circle {
  // constant is able not to change the value
   static const double pi = 3.14;

   double ni=2.45;

  static void calculator(){
     print("this is inside a calculator");
    // normalFunction();  // this is not allowed
    //this.ni    // this is also not allowed
   }

   void normalFunction(){
    Circle.calculator();
   }

}