

void loops(){

  var a=10;
  // for loop
  for(var i=0; i<4 ; i++){
    print(i);
  }
  // while loop
  while(a>4){
    print(a);
    a++;
  }

  // do while loop
  do{
    print(a);
    a++;


  }while(a>4);

  List list =["mercury",'venus','marks','earth','saturn'];

  for(var value in list){
    print(value);
  }

// it break the loop when reaches that value
  for( var i =0; i<20; i++ ){

    print(i);
    if(i==7){
      break;
    }
  }

  // it skips that statement when reaches that value
  for(var i=0; i<=20;i++){
    if(i==5){
      continue;
    }
    print(i);

  }


}