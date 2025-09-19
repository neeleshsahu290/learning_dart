// Lambda function
// Note in dart fun is always an object


// ignore_for_file: prefer_function_declarations_over_variables

void lambda(){


 Function  addTwoNumber = (int num1, int num2 ){
                        int sum = num1+ num2;
                      print(sum);
                      };
 var multiplyByFour = (int number){
   return number *  4;
 };

 // Function expression convert into short hand arrow
 Function  adNumber = (int num1, int num2 )=> print(num1+num2);



 // calling Lambda functions
  addTwoNumber(2,8);
  print(multiplyByFour(7));
  adNumber(7,8);

}

void addTwoNumber(int num1, int num2 ){
  var sum = num1+ num2;
  print(sum);
}