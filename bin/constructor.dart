// objectives
// 1> default constructor
// 2> parameterized constructor
// 3> named constructor
// 4> constant constructor

void constructor(){

Student(5,"mjsdk");
var student= Student.myNamedConstructor(5, "neel");
}


class Student {
  int id;
  String name;

  // default constructor without any parameter
  /* Student(){
    print("this is the default constructor");
  }*/

  /* Student(int _id,String _name){
    id= _id;
        name=_name;

  }*/


  // this is parameterized constructor
  Student(this.id, this.name);

  // this is named constructor
  Student.myNamedConstructor(this.id, this.name);


}
