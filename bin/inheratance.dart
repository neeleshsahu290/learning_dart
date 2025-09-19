// inheratance finding in class
// video number 30

void inheratance(){
  var dog = Dog();
  print("");
  var cat = Cat("nkgs");
  cat.age=5;
  print(cat.age);
  cat.eat();
  dog.eat();

}

class Dog extends Animal{
  var breed;

  void bark(){
    print("BARK");
  }

  // method ovriding
  void eat(){
    // this is to get the previous methods also
    super.eat();
    print("Dog is Eating");
  }

  // dog constructor
   Dog():super("type"){
    print("This is a dog class constructor");
   }
   // this constructor only called when seperately called
   Dog.myNamedConstructor():super("enjkdflj") {
    print("This is a DOg named constructor");
   }

}

class Cat extends Animal{
  var age;

  Cat(super.type);

  void meow(){
    print("MEOW");
  }



}

class Animal{
  var color;
  void eat(){
    print("Animal is Eating");
  }
  Animal(String type){
    print("This is a animal class constructor");
  }

}