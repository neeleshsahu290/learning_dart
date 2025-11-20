// Here is a curated list of 100 intermediate Dart practice problems compiled from multiple quality resources. These include a variety of programming exercises to deepen understanding of Dart programming language concepts such as control flow, input/output, functions, lists, strings, algorithms, and data structures:

// 1. Write a Dart program to display the current date and time.
import 'dart:math';

int getDateTime() {
  return DateTime.now().microsecondsSinceEpoch;
}

// 2. Accept radius of a circle and compute the area.
double getAreaOfCircle(int radius) {
  return pi * radius * radius;
}

// 3. Accept first and last name and print in reverse order.
void printReverseName(String firstName, String lastName) {
  print(firstName.split("").reversed.join(""));
  print(lastName.split("").reversed.join());
}

// 4. Accept comma-separated numbers, generate list and tuple.
void convertStrToList(String csNum) {
  csNum
      .split(",")
      .map(
        (e) => int.parse(e),
      )
      .toList();
  // dynamic tuple not possible in dart
}

// 5. Test whether a number is within 100 of 1000 or 2000.
bool checkNumisInWithin(int num) {
  if ((((num - 1000).abs()) >= 100) || (((num - 2000).abs()) >= 100)) {
    return true;
  }
  return false;
}

// 6. Calculate the sum of three numbers; if equal, return thrice the sum.
int calculateSumWithCondition(int a, int b, int c) {
  int sum = a + b + c;
  if (a == b && b == c) {
    return 3 * sum;
  }
  return sum;
}

// 7. Add "Is" to the front of a string if it doesn't already start with "Is".
String addIsToStr(String str) {
  if (str.startsWith("Is"))
    return str;
  else
    return "Is$str";
}

// 8. Return a string which is n copies of a given string.

// 9. Check if a given number is even or odd.
isEvenNum(int num) {
  if (num % 2 == 0) return true;
  return false;
}

// 10. Count the number of 4s in a given list.
int fourssOccurance(List<int> ls) {
  int count = 0;
  for (var num in ls) {
    if (num == 4) count++;
  }
  return count;
}

// 11. Print all even numbers from a number list until number 237 appears.
printNum(List<int> ls) {
  ls.sort();
  for (int num in ls) {
    if (num > 237) break;
    print(num);
  }
}

// 12. Print colors from one list that are not present in another.
printColorsNotOneAnother(List<int> color1, List<int> color2) {
  return [
    ...color1.where(
      (element) => color2.contains(color1),
    ),
    ...color2.where(
      (element) => color1.contains(color1),
    )
  ];
}

// 13. Accept base and height of a triangle to compute its area.
double areaOfTrinagele(double height, double base) {
  return (1 ~/ 2) * height * base;
}

// 14. Compute greatest common divisor (GCD) of two integers.
int greatestCommonDiviser(int a, int b) {
  while (b != 0) {
    int temp = b;
    b = a % b;
    a = temp;
  }
  return a;
}

// 15. Compute least common multiple (LCM) of two integers.
int lowestCommonDivisers(int a, int b) {
  int gcd = greatestCommonDiviser(a, b);
  return (a * b) ~/ gcd;
}

// 16. Sum three integers but return zero if any two are equal.
int sumAndReturn(int a, int b, int c) {
  if (a == b && b == c) {
    return 0;
  }
  return a + b + c;
}

// 17. Sum two integers but return 20 if sum is between 15 and 20.
int sumAndReturnBetween20(int a, int b) {
  int sum = a + b;
  if (sum >= 15 && sum <= 20) {
    return 20;
  }
  return sum;
}

// 18. Return true if two integers are equal or their sum/difference is 5.
bool checkAandReturn(int a, int b) {
  if (a == b || (a - b) == 5 || (a + b) == 5) {
    return true;
  }
  return false;
}

// 19. Sum the first n positive integers.
int sumOfFirstN(int n) {
  return n * (n + 1) ~/ 2;
}

// 20. Convert height from feet/inches to centimeters.
double convertHeightToCm(int feet, int inches) {
  int totalInches = (feet * 12) + inches;
  return 2.54 * totalInches;
}

// 21. Calculate the hypotenuse of a right-angled triangle.
double createHypontenuse(int base, int height) {
  return sqrt(pow(base, 2) + pow(height, 2));
}

// 22. Check if a string is a palindrome.
bool checkPalidrome(String str) {
  return str == (str.split("").reversed.join(""));
}

// 23. Filter and create a new list with only even elements from a list.
List<int> getEvenOnly(List<int> ls) {
  return ls
      .where(
        (e) => e.isEven,
      )
      .toList();
}
// 24. Implement a guessing game between 0 and 100.

// 25. Test if a number is prime using a function.
bool isPrimeNumber(int num) {
  if (num <= 1) return false;
  if (num == 2) return true;
  for (int i = 3; i <= num; i += 2) {
    if (num % i == 0) return false;
  }
  return true;
}

// 26. Reverse a string without using built-in functions.
String reverseWithoutFun(String str) {
  String reverseStr = "";
  for (int i = 1; i <= str.length; i++) {
    reverseStr = reverseStr + str[str.length - i];
  }
  return reverseStr;
}

// 27. Count the occurrences of each character in a string.
countOccurances(List<int> ls) {
  Map<int, int> items = {};
  for (var e in ls) {
    items[e] = (items[e] ?? 0) + 1;
  }
  return items;
}

// 28. Merge two sorted lists into one sorted list.
List mergeSortedList(List a, List b) {
  List ls = ([...a, ...b]);
  ls.sort();
  return ls;
}

// 29. Remove duplicates from a list.
removeDuplicates(List ls) {
  List newList = [];
  for (var item in ls) {
    if (!newList.contains(item)) {
      newList.add(item);
    }
  }
}

removeDuplicates2(List ls) {
  return ls.toSet().toList();
}

// 30. Find the max and min in a list without built-in functions.
findMaxAndMin(List ls) {
  if (ls.isEmpty) return;

  var min = ls[0];
  var max = ls[0];
  for (var item in ls) {
    if (item < min) {
      min = item;
    }
    if (item > max) {
      max = item;
    }
  }
}

// 31. Sort a list using bubble sort.

// 32. Find the second largest element in a list.
int? secondLargestElement(List<int> ls) {
  ls.sort();
  return ls.length > 2 ? ls[ls.length - 2] : null;
}

// 33. Check if two strings are anagrams.
// 34. Calculate factorial of a number using recursion.
// 35. Generate Fibonacci series up to n terms.
// 36. Find the missing number in a list of consecutive integers.
// 37. Implement binary search on a sorted list.
// 38. Convert a decimal number to binary.
// 39. Check if a number is a perfect number.
// 40. Generate all subsets of a set.
// 41. Find the sum of digits of an integer.
int sumOfDigit(int num) {
  return num.toString().split("").map(int.parse).reduce(
        (a, b) => a + b,
      );
}

// 42. Check if a year is a leap year.
// 43. Find all prime numbers up to n.
// 44. Find the length of a string without using length property.
int findTheLength(String str) {
  int length = 0;
  List<String> ls = str.split("");
  try {
    while (true) {
      ls[length];
      length++;
    }
  } catch (e) {}
  return length;
}

// 45. Count vowels and consonants in a string.
seprateandCount(String str) {
  List vowels = [];
  List consonents = [];
  List nV = ['a', 'e', 'i', 'o', 'u'];
  for (var ch in str.toLowerCase().split("")) {
    if (RegExp(r'[a-z]').hasMatch(ch)) {
      if (nV.contains(ch))
        vowels.add(ch);
      else
        consonents.add(ch);
    }
  }
  print("vowels: ${vowels.length}, Consonents: ${consonents.length}");
}

// 46. Capitalize the first letter of each word in a string.
capitailzeTheFirst(String str) {
  List strLs = str.split(' ');
  strLs.map((word) {
    if (word.isEmpty) return '';

    return word[0].toUpperCase() + word.substring(1);
  });
  return strLs.join(" ");
}

// 47. Remove all vowels from a string.
removeVowels(String str) {
  List nV = ['a', 'e', 'i', 'o', 'u'];
  return str
      .split("")
      .where(
        (e) => !nV.contains(e),
      )
      .join("");
}

// 48. Reverse the words in a sentence.
reverseWords(String sent) {
  return sent.split(" ").reversed.join(" ");
}

// 49. Find the intersection of two lists.
intersectionOfLists(List ls1, List ls2) {
  List intersectionList = [];
  for (var item in ls1) {
    if (ls2.contains(item)) {
      intersectionList.add(item);
    }
  }
}

// 50. Find the union of two lists.
unionOfList(List ls1, List ls2) {
  return [...ls1, ...ls2].toSet();
}

// 51. Calculate the median of a list of numbers.
median(List<int> ls) {
  ls.sort();
  int length = ls.length;
  int mid = ls.length ~/ 2;
  if (length % 2 != 0) {
    return ls[mid];
  } else {
    return (ls[mid - 1] + ls[mid]) ~/ 2;
  }
}
// 52. Implement a stack using list.

// 53. Implement a queue using list.
// 54. Check if a string has all unique characters.
checkAllUnique(String str) {
  Map map = {};
  for (String ch in str.split("")) {
    map[ch] = (map[ch] ?? 0) + 1;
    if (map[ch] > 1) {
      return false;
    }
  }
  return true;
}

checkAllUnique2(String str) {
  return str.length == str.split('').toSet().length;
}

// 55. Calculate the power of a number using recursion.

// 56. Flatten a nested list.
// 57. Find the longest palindrome substring.
// 58. Check if a number is Armstrong number.
// 59. Find the maximum product of two integers in a list.
// 60. Find the difference between two lists.
// 61. Implement calculator with basic operations.
// 62. Rotate a list by k positions.
// 63. Find all pairs in a list that sum to a given number.
// 64. Count the frequency of words in a string.
// 65. Implement factorial using an iterative method.
// 66. Find the depth of nested lists.
// 67. Merge intervals in a list of intervals.
// 68. Calculate the sum of all elements in a matrix.
// 69. Transpose a matrix.
// 70. Check if two matrices are equal.
// 71. Find saddle points in a matrix.
// 72. Determine if a matrix is symmetric.
// 73. Find the largest row sum in a matrix.
// 74. Perform matrix multiplication.
// 75. Implement a function to check for balanced parentheses.
// 76. Find the longest increasing subsequence.
// 77. Remove all duplicates from a string.
// 78. Find distinct elements in two lists.
// 79. Replace all spaces in a string with ‘%20’.
// 80. Remove the nth node from the end of a linked list.
// 81. Reverse a linked list.
// 82. Detect a cycle in linked list.
// 83. Implement a priority queue.
// 84. Implement binary tree traversal (inorder, preorder, postorder).
// 85. Find height of a binary tree.
// 86. Check if a binary tree is a binary search tree.
// 87. Serialize and deserialize a binary tree.
// 88. Implement breadth-first search on a graph.
// 89. Implement depth-first search on a graph.
// 90. Detect cycle in a graph.
// 91. Find shortest path in an unweighted graph.
// 92. Implement Dijkstra’s algorithm.
// 93. Find first non-repeating character in a string.

// 94. Check if two strings are rotations of each other.
bool isStringsRotationsEachOther(String a, String b) {
  if (a.length != b.length) return false;
  String doubleStr = a + a;
  if (doubleStr.contains(b)) {
    return true;
  }
  return false;
}

// 95. Find the longest common prefix.
String longestCommonPrefix(List<String> ls) {
  if (ls.isEmpty) return "";
  String prefix = ls[0];

  for (int i = 0; i < ls.length; i++) {
    while (!ls[i].startsWith(prefix)) {
      prefix = prefix.substring(0, ls.length - 1);
      if (prefix.isEmpty) return "";
    }
  }
  return prefix;
}

// 96. Implement a function to find summation of digits until single digit remains.
int sumToSingleDigit(int num) {
  while (num >= 10) {
    int sum = 0;
    while (num > 0) {
      sum += num % 10;
      num ~/= 10;
    }
    num = sum;
  }
  return num;
}

// 97. Find the missing number in an array of size n-1.
findMissingNum(List<int> arr) {
  arr.sort();
  for (int i = 1; i <= arr.length; i++) {
    if (arr[i - 1] != i) return i;
  }
  return arr.length + 1; // missing number is the last one
}

// 98. Calculate the running sum of a list.
List<int> runningSum(List<int> nums) {
  List<int> res = [];
  int sum = 0;
  for (var it in nums) {
    sum += it;
    res.add(sum);
  }
  return res;
}

// 99. Check if two arrays are equal.
bool checktwoArraysAreEqual(List a, List b) {
  if (a.length != b.length) return false;
  a.sort();
  b.sort();
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

// 100. Implement a function to reverse words in a string.
reverseTheWords(String Str) {
  Str.split(" ").reversed.join(" ");
}
