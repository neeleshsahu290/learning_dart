


// optional position parameters
void getcity (String city1,String city2, [String? city3]){

  print(city1);
  print(city2);
  print(city3);

}

// named parameters
void findvolume(int length,{required int breath , required int height  }){
  print('the volume of block is ${length * breath*height}');

}

void findvolumebox(int length,{ int breath=1 ,  int height=1  }){
  print('the volume of block is ${length * breath*height}');

}



void perimeterOfRectangele(int length,int breath )=> print("Perimeter of rectangele id=s ${length+breath}");

int getArea(int length, int breath)=> length*breath;
