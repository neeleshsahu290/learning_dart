// Default getter and setter
// custom getter and setter

void getandset(){
 var student = Student();

     // calling default setter
     student.name = 5 ;
     print(student.name);

     // calling custom setter
     student.percentage=5;



}

class Student{

   var name;

   var _percentage;

  int get percentage => _percentage;

  set percentage(int percentage) {
    _percentage = percentage;
  }

}