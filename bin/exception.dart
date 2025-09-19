
void exception(){

  // ~/ is used for divisible in int
  //  / is used for divisible in double


  // Case 1 when you know a exception to be thrown, use ON clause
  try{

    var num = 20~/0 ;
    print(num);

  } catch(e){
    print("value is not divisible");
  }

  // Case 2 when you dont know the exception simply use catch block

  try{
    var num = 20~/0 ;

  }catch(e){

    print('the exception is $e');
  }

  // Case 3 using stsck trsce know a event occurd before the exception thrown

  try{
    var num = 20~/0 ;

  }catch(e,s){

    print('the exception is $e');
    print('event occured before error$s');
  }

  // Case 4 finally clause is always executed

  try{
    var num = 20~/0 ;

  }catch(e){

    print('the exception is $e');
  }finally{
    print("no matter what happend this statement is always executed");
  }

  // Case 5 Custom Exception
  try {
    depositMoney(-200);
  }on DepositException{
    print("no money deposit");

  }


}


void depositMoney(int amount){
  if(amount<5){
    throw DepositException();
  }

}

class DepositException implements Exception {

  void errorMessage() {
     print("you cannot enter amount less than zero");
  }


}