void streamAmdFuture(){

}

 getSum(int a, int b) async {
  int sum= a+b;
  return sum;
}

Stream<int> getSum2(int a, int b) async*{
  int sum = a+b;
  //return sum;
}