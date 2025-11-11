import 'package:learning_dart/questions_dart.dart';
import 'package:learning_dart/sove.dart';

// void main() {
// //  var value = twoSum([2, 7, 11, 15], 9);
// //  print(value);

// //  lengthOfLongestSubstring("ppwwkestrac");
//   var res = reverseList([1, 2, 3, 4]);
//   print(res);
//}

void main() {
  // List<int> a = [8, 4, 3, 1, 5, 7, 9, 5, 7, 7, 2, 2, 9, 9, 9];

  // countOccurance(a);

  // 2. Remove vowels from a string
  var b = "Your name is Ram";
// Expected output: "Yr nm s Rm"

  removeVowels(b);
}

countOccurance(List<int> ls) {
  Map valueOccurance = {};

  for (var num in ls) {
    valueOccurance[num] = (valueOccurance[num] ?? 0) + 1;
  }

  print(valueOccurance);
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
