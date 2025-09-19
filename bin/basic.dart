

void dataTypes(){

  // int data type
  int value= 10;
  var v2= 2;

  // double data type
  double b = 12.54;
  var c =23.23;

  // boolean data type
  bool k= true;
  var x= false;


}

void literals(){

  // Literals
  var name= "str";
  4;
  "hdshjd";
  true;

  // various types to define string literals
  var s1="name";
  var s2='name';
  var s3='it\'s easy';
  var s4="it's easy";

  // string interpolation in dart

  var n= "orange";
  print("thie is $n");

}


void ifElseBlock(){
  var a= 10;
  var b=5;

  if(a>5){
    print(a);
  } else if (a<10){
    print(a);
  }

  // conditional statements
  a<b ? print("a is smaller"):print("b is smaller");

  var smallnum = a<b? a : b;

  print(smallnum);

}


void switchCaseStatement(){

  var grade='E';

  switch(grade){
    case 'A': print("Excellent");
    break;

    case 'B': print('very good');
    break;

    case 'c': print('good');
    break;

    default : print('you have failed');

  }

}