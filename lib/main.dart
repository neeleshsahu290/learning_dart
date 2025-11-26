

void main() {
  

}

removeVowels(String str) {
  List<String> vowels = ["a", "e", "i", "o", "u"];

  var sentence = str
      .split("")
      .where((element) => !vowels.contains(element))
      .toList()
      .join("");

  print(sentence);
}
