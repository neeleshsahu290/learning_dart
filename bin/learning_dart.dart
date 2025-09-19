
import "dart:io";

void main() {
//  stdout.write("* ");


  getMinMax([1,2,5,8,20]);

}

void secondLargest(List<int> arr ){
 int i = 0;
 int j =0;
 for(int k in arr){
   if(k>i){
     j=i;
     i =k;
   }
 }
 print(j);

 for( int i=0; i<5;i++){

 }

}


void getMinMax(List<int> arr ){
  int min = 2147483647;
  int max =  -2147483648;



  for( int i=0; i<arr.length-1;i++){
    var sum =0;
    for(int j=0; j<arr.length-1;j++){
      if(i!=j){
     sum=   sum+arr[j];
      }
    }

    if(sum > max){
      max =sum;
    }
    if(sum<min){
      min =sum;
    }

    print(min);
      print(max);

  }

}




