import "dart:io";

void loop(){
  for(var i=1; i<=15;i++){

    if (i % 3 == 0 && i %5!=0) {
      print("fizz");
    }else if(i % 5==0 && i % 3!=0 ){
      print('buzz');
    } else if(i% 3==0 && i %5==0){
      print('FizzBuzz');
    }else{
      print(i.toString());

    }

  }


  for(var i=0;i<=15;i++){

  }
}

// reversedString(String s){
//
//   var a ="neelesh";
//  a= a.split("").reversed.join();
//
//   print(a);
// }


pandromeString(){
  var a ="neelesh";
 var a1= a.split("").reversed.join();

 if(a==a1){
   print("true");
 }else{
   print("false");
 }
}


getMatchChar(){
  var a ="neelesh";
 a= a.replaceAll("e", "k");
 print(a);
}

getchar(){
  String sampleString = 'asdasfgalfnvcanalsdkalkcmaslksavnajskhauroewu982138954fndslkjanca135faca31asdcgdsa';

  var sampleStringAsList = sampleString.split('');
  var sampleStringAsSet = sampleStringAsList.toSet();

  var uniqueCharactersList = [];
  for(var character in sampleStringAsSet){
    if(sampleStringAsList.indexOf(character) != sampleStringAsList.lastIndexOf(character)){
      uniqueCharactersList.add(character);
    }
  }

  print(uniqueCharactersList);


}



// reverse the String
String reverseString(String str){
  return str.split("").reversed.join("");
}






//Ques 2  print the list by setting buzz at multiple of 3 and man at multiple of 5
printOnetoHun() {
  for(int i=0; i<100;i++){
    if(i%3==0){
      print("buzz");
    }else if(i%5==0){
      print("man");
    }else{
      print(i.toString());
    }

  }
}

// // Ques 3 swap two number without implementing third variable
swapTwoNumbers() {

  int a=5;
  int b=2;
  b= a+b;
  a= b-a;
  b=b-a;
  print("a=> $a , b=> $b");
}

// @ues 4 String contains vowels or not
bool stringContainsVowels( String str){
  // lowercase the sting
  str= str.toLowerCase();

  if(str.contains("a")||str.contains("e")||str.contains("i")||str.contains("o")||str.contains("u")){
    return true;
  }
  return false;



}


// Ques 5 check a number is prime or not
bool isPrimeNumber(int number){

  if (number % 2 == 0) {
    return true;
  }

  return false;

}

// Ques 6 check list of int contains only odd number
bool listHavingOnlyOddNum( List<int> list)  {

  for(var i in list){
    if(i%2==0){
      return false;
    }
  }
  return true;

}


//Ques 7 check a String weather a Palindrome or not
//Palindrome means after reversing a string the string is same
bool isStringPalindrome( String str){
  var reversedSring=str.split("").reversed.join("");

  if (reversedSring==str){
    return true;
  }
  return false;
}

//Ques 8 remove blank spaces in string
String  removeBlankSpacesInString(String str){

  List<String> ls= str.split("");
  ls.removeWhere((item)=> item==" ");
  return ls.join("");
}



//Ques 9 remove leading and trailing space from string
String removeLeadingandtrailingSpaceinString(String str){
  return str.trim();
}

//Ques 10 sort array in Dart
sortedArray(List arr) =>   arr.sort();
//
// //Ques 11 find factorial of a number
// fun factorial(n: Long): Long {
// return if (n == 1L) 1 else n * factorial(n - 1)
// }
//
// //Ques 11 reverse a list in kotlin
// fun reverseArrayList(list:List<String>): List<String> {
// return  list.reversed()
// }
//
// //Ques 12  check two arrays contains same element
// fun checkArrayContainsSameElement(){
//   val arr1 = intArrayOf(1,2,7)
//   val arr2 = intArrayOf(4,8,7)
//
//   var  cont =0
//
//   for (element in arr1){
//
//     arr2.map {
//       if (it==element){
//         cont++
//         println("contain element is $it")
//       }
//     }
//   }
//
//   println("total element count is $cont")
// }
//
// //Ques 13 sum of integers
// fun sumOfIntArray(arr:IntArray):Int{
// var sum= 0
// for (i in arr){
// sum += i
// }
// return sum
// }
//
// //Ques 14 find Second-Highest Number
// private fun findSecondHighest(array: IntArray): Int {
// var highest = Int.MIN_VALUE
// var secondHighest = Int.MIN_VALUE
// for (i in array) {
// if (i > highest) {
// secondHighest = highest
// highest = i
// } else if (i > secondHighest) {
// secondHighest = i
// }
// }
// return secondHighest
// }
//
// //Ques 15 merge two list in kotlin
// fun mergedlist(){
//   val list1:ArrayList<Int> =ArrayList()
//   val list2:ArrayList<Int> = ArrayList()
//   for (i in 1..20){
//     list1.add(i)
//     list2.add(i)
//   }
//   val merglist:ArrayList<Int> = ArrayList()
//   merglist.addAll(list1)
//   merglist.addAll(list2)
// }
//
// // Ques 16 Shuffle  a array
// fun shuffleArray(){
//   val array = intArrayOf(1, 2, 3, 4, 5, 6, 7)
//
//   val rand = Random()
//
//   for (i in array.indices) {
//     val randomIndexToSwap: Int = rand.nextInt(array.size)
//     val temp = array[randomIndexToSwap]
//     array[randomIndexToSwap] = array[i]
//     array[i] = temp
//   }
//   println(array.contentToString())
// }
//
// //Ques 17 remove all occurrences of a given character from input String
// fun removeOccurrencesOfString(str:String):String{
//
// return str.replace("a","")
// }
//
// //Ques 18 get a distinct characters and their count in a String
// fun getDistinctCharinString(str:String,char:Char){
//
// var count=0
//
// for (i in str.toCharArray()){
// if (i==char){
// count++
// }
// }
// println("The count of char in the string is $count")
// }
//
//Ques 19 Create a pyramid
//* * * * *
//* * * *
//* * *
//* *
//*
createPyramid1(){

  for(int i=0;i<5;i++){

    for( int j =i;j<5 ;j++){
      stdout.write("*");
    }
    print("");
  }




}

//Ques 20 Create a pyramid
//*
//* *
//* * *
//* * * *
//* * * * *
createPyramid2(){
  for(int i=0;i<5;i++){
    for(int j=0;j<=i ;j++) {
      stdout.write("* ");
    }print("");
  }



}

//Ques 21 Min element in sorted or rotated array
int findMinElement(List<int> list){
  int minvalue = double.maxFinite.toInt();

  list.forEach((element) {
    if(element < minvalue){
      minvalue =element;
    }
  });

  return minvalue;
}

//Ques 22 Largest subarray with equal number of 0s and 1s
int largest(List<int> arr){
  var maxValue = -double.maxFinite.toInt();
  arr.forEach((element) {
    if(element> maxValue){
      maxValue =element;
    }
  });
  return maxValue;
}


