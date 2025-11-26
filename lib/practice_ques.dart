import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:learning_dart/sove.dart';
import 'package:collection/collection.dart';

void main() {
  var ls = moveZerosEnd([0, 1, 6, 0, 4, 6]);
  print(ls);
}
// . Arrays & Strings

// Easy:
// 	1.	Reverse words in a string.
String reverseTheWords(String str) {
  return str.split(" ").reversed.join(" ");
}

// 	2.	Check if a string is a palindrome.
bool checkStringPalidrome(String str) {
  return (str.split("").reversed.join("")) == str;
}

// 	3.	Move all zeros to the end of the array.
List<int> moveZerosEnd(List<int> ls) {
  ls.sort(
    (a, b) => a != 0 && b == 0 ? -1 : 1,
  );
  return ls;
}

// 	4.	Find duplicates in an array.
List findDuplicates(List ls) {
  Map<dynamic, int> map = Map();
  List duplicates = [];
  for (var item in ls) {
    map[item] = (map[item] ?? 0) + 1;
    if ((map[item] ?? 0) > 1) {
      duplicates.add(item);
    }
  }
  return duplicates;
}

// 	5.	Find the first non-repeating character in a string.
String? findFirstNonRepeatatingChar(String str) {
  str.replaceAll(" ", '');
  Map<String, int> map = {};
  List<String> nchLs = [];
  for (var ch in str.split("")) {
    map[ch] = (map[ch] ?? 0) + 1;
    if (map[ch] == 1) nchLs.add(ch);
    if (map[ch]! > 1 && nchLs.contains(ch)) nchLs.remove(ch);
  }
  if (nchLs.isNotEmpty) return nchLs[0];
  return null;
}

// 	6.	Count frequency of elements in an array.
Map<dynamic, int> findFrequency(List ls) {
  Map<dynamic, int> map = {};
  for (var item in ls) {
    map[item] = (map[item] ?? 0) + 1;
  }
  return map;
}

// 	7.	Check if two strings are anagrams.
bool checkAnagrams(String a, String b) {
  a.replaceAll(" ", "");
  b.replaceAll(" ", "");
  List<String> a1 = a.split("")..sort();
  List<String> b1 = b.split("")..sort();
  return a1.join("") == b1.join("");
}

// 	8.	Merge two sorted arrays.
List mergeArrays(List a, List b) {
  a.addAll(b);
  a.sort();
  return a;
}

// 	9.	Find all pairs with a given sum.
getAllPairsOfSum(List<int> ls, int target) {
  Map<int, int> sum = {};
  List<int> seen = [];
  for (int num in ls) {
    int secondDigit = target - num;
    if (seen.contains(secondDigit)) sum[num] = target;
    seen.add(num);
  }
  return sum;
}

// 	10.	Rotate an array by k positions.
rotatetheArray(List<int> ls, int posRot) {
  List<int> l1 = [];

  for (int i = 0; i < posRot; i++) {
    l1.add(ls[i]);
    ls.removeAt(i);
  }
  ls.addAll(l1);
  return ls;
}

// Medium:
// 11. Maximum product subarray.
// 12. Longest substring without repeating characters.
// 13. String compression.
// 14. Intersection of two arrays.
// 15. Maximum subarray sum (Kadane’s algorithm).

// Tough:
// 16. Longest palindromic substring.
// 17. Minimum window substring.
// 18. Word break problem.
// 19. Longest substring with at most K distinct characters.
// 20. Sliding window maximum.

// ⸻

// 2. Linked Lists

// Easy:
// 21. Reverse a linked list.
// 22. Find the middle of a linked list.
// 23. Remove N-th node from the end.
// 24. Merge two sorted linked lists.

// Medium:
// 25. Detect a cycle in a linked list.
// 26. Check if a linked list is a palindrome.
// 27. Add two numbers represented by linked lists.

// Tough:
// 28. Flatten a multilevel linked list.
// 29. Copy a linked list with random pointers.
// 30. Intersection point of two linked lists.

// ⸻

// 3. Trees & Graphs

// Easy:
// 31. Inorder, Preorder, Postorder traversal.
// 32. Level order traversal.
// 33. Maximum depth of a binary tree.
// 34. Check if a binary tree is balanced.
// 35. BFS and DFS in graphs.

// Medium:
// 36. Lowest common ancestor in a BST.
// 37. Convert sorted array to BST.
// 38. Number of islands problem.
// 39. Diameter of a binary tree.
// 40. Detect cycle in a graph.

// Tough:
// 41. Serialize and deserialize a tree.
// 42. Clone a graph.
// 43. Topological sort.
// 44. Minimum spanning tree (Kruskal/Prim).
// 45. Shortest path (Dijkstra/Bellman-Ford).

// ⸻

// 4. Dynamic Programming (DP)

// Easy:
// 46. Fibonacci numbers.
// 47. Climbing stairs problem.
// 48. Unique paths in a grid.
// 49. Minimum cost path.
// 50. Subset sum problem.

// Medium:
// 51. Longest common subsequence.
// 52. Longest increasing subsequence.
// 53. Maximum sum increasing subsequence.
// 54. Coin change problem.
// 55. Palindromic substring count.

// Tough:
// 56. Edit distance problem.
// 57. Partition equal subset sum.
// 58. Decode ways (number of ways to decode digits to letters).
// 59. Maximum product cutting problem.
// 60. Minimum number of jumps to reach end.

// ⸻

// 5. Stack & Queue

// Easy:
// 61. Implement a stack using array/linked list.
// 62. Implement a queue using array/linked list.
// 63. Valid parentheses check.

// Medium:
// 64. Min stack (stack that returns minimum in O(1)).
// 65. Next greater element.
// 66. Implement circular queue.
// 67. Evaluate reverse polish notation.

// Tough:
// 68. Largest rectangle in histogram.
// 69. Sliding window maximum.
// 70. Implement LRU cache.

// ⸻

// 6. Hashing

// Easy:
// 71. Two sum problem.
// 72. Count subarrays with equal number of 0s and 1s.
// 73. Find duplicates in array using hashing.

// Medium:
// 74. Longest consecutive sequence.
// 75. Group anagrams.
// 76. Top K frequent elements.
// 77. Intersection of two arrays II.
// 78. Check if array is a subset of another array.

// Tough:
// 79. Happy number problem.
// 80. Subarray sum equals k.
// 81. Longest substring with at most K distinct characters.

// ⸻

// 7. Sorting & Searching

// Easy:
// 82. Binary search in sorted array.
// 83. Merge sort and quick sort.
// 84. Find peak element in array.
// 85. Count occurrences of element in sorted array.

// Medium:
// 86. Search in rotated sorted array.
// 87. Kth largest/smallest element.
// 88. Dutch national flag problem.
// 89. Median of two sorted arrays.

// Tough:
// 90. Allocate minimum pages (book allocation problem).
// 91. Inversion count in array.

// ⸻

// 8. Math & Bit Manipulation

// Easy:
// 92. Reverse integer.

// 93. Check if a number is power of two.
// 94. Count set bits in an integer.
// 95. Find missing number in array 1..N.

// Medium:
// 96. Single number (all elements appear twice except one).
// 97. Add two numbers without using + or -.
// 98. Multiply two numbers without using *.

// Tough:
// 99. Detect if a number is a palindrome.
// 100. XOR of all numbers from 1 to N.
// 101. Divide two integers without using / operator.

// 🧩 1. Strings
// 	1.	Reverse a string without using .reversed.
// 	2.	Check if two strings are anagrams.
// 	3.	Count vowels and consonants in a string.
countVowelsAndConsent(String str) {
  int vowels = 0;

  List lsVOw = ['a', 'e', 'i', 'o', 'u'];
  for (String ch in str.split('')) {
    if (lsVOw.contains(ch.toLowerCase())) vowels++;
  }
  int consonets = str.split('').length - vowels;
  print("vowels=> $vowels , consonents => $consonets");
}

// 	4.	Remove duplicate characters from a string.
// 	5.	Find the first non-repeating character.
// 	6.	Replace multiple spaces with a single space.
replaceMultipleSpaceWithSngle(String str) {
  List<String> a = [];
  int sp = 0;
  for (String ch in str.split("")) {
    if (ch == " ") {
      sp++;
      if (sp < 2) {
        a.add(ch);
      }
    } else {
      sp = 0;
      a.add(ch);
    }
  }
  return a.join('');
}

// 	7.	Check if a string is a palindrome (ignore spaces/punctuation).
// 	8.	Capitalize the first letter of each word.
String capatilizeFirstWord(String str) {
  return str
      .split(' ')
      .map((word) => word.isEmpty
          ? word
          : word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join(" ");
}

// 	9.	Convert camelCase to snake_case.
camelCasetoSnakeCase(String str) {
  return str
      .split(" ")
      .map(
        (e) => e.isEmpty ? e : e.toLowerCase(),
      )
      .join("_");
}

// 	10.	Find the most frequent character in a string.
String? findMostFreqChar(String str) {
  if (str.isEmpty) return null;

  Map<String, int> freq = {};

  // Count frequency of each character
  for (String ch in str.split('')) {
    freq[ch] = (freq[ch] ?? 0) + 1;
  }

  // Find character with maximum frequency
  String maxChar = '';
  int maxFreq = 0;

  for (var entry in freq.entries) {
    if (entry.value > maxFreq) {
      maxFreq = entry.value;
      maxChar = entry.key;
    }
  }

  print('Character frequencies: $freq');
  print('Most frequent character: $maxChar ($maxFreq times)');
  return maxChar;
}

// 	11.	Count occurrences of each word in a sentence.
// 	12.	Truncate a string and add “…” if it exceeds a certain length.
String translucateString(String str, int len) {
  return str.length < len ? str : "${str.substring(0, len)}...";
}

// 	13.	Find all substrings of a given string.
List<String> getSubStrings(String str) {
  List<String> sub = [];
  for (int i = 0; i < str.length; i++) {
    for (int j = i + 1; j < str.length - 1; j++) {
      sub.add(str.substring(i, j));
    }
  }
  return sub;
}

// 	14.	Remove specific characters from a string.
String removeChar(String str, String ch) {
  return str.replaceAll(ch, '');
}

// 	15.	Swap case of each character (upper ↔ lower).
String swapCase(String str) {
  return str
      .split("")
      .map(
        (ch) => ch.toUpperCase() == ch ? ch.toLowerCase() : ch.toUpperCase(),
      )
      .join('');
}

// 	16.	Count digits, letters, and special symbols in a string.
count(String str) {
  int letter = 0;
  int digit = 0;
  int spChar = 0;
  for (String ch in str.split('')) {
    if (RegExp(r'[a-zA-Z]').hasMatch(ch))
      letter++;
    else if (RegExp(r'\d').hasMatch(ch))
      digit++;
    else
      spChar++;
  }
}
// 	17.	Check if two strings are rotations of each other.
// 	18.	Remove HTML tags from a string.
// 	19.	Extract all URLs from a text.
// 	20.	Mask part of a string (e.g., email masking).

// ⸻

// 📋 2. Lists & Collections
// 	21.	Remove duplicates from a list.
removeDuplicates(List ls) {
  return ls.toSet();
}

// 	22.	Find the second largest element in a list.
secondLargest(List<int> ls) {
  ls.sort();
  if (ls.length > 1) {
    return ls[1];
  }
  return null;
}

// 	23.	Merge two sorted lists.
// 	24.	Rotate a list left/right by n positions.
// 	25.	Move all zeros to the end of a list.
// 	26.	Reverse a list in place.
// 	27.	Flatten a nested list.
List<dynamic> flattern(List ls) {
  List x = [];
  for (var i in ls) {
    if (i is List) {
      x.addAll(flattern(i));
    } else {
      x.add(i);
    }
  }
  return x;
}

// 	28.	Count frequency of elements in a list.
// 	29.	Get common elements between two lists.
getCommonElement(List a, List b) {
  a.where(
    (element) => b.contains(element),
  );
  return a;
}

// 	30.	Remove all falsy/null/empty values from a list.
// 	31.	Shuffle a list randomly.
suffleRandom(List ls) {
  ls.shuffle(Random());
  return ls;
}

// 	32.	Split a list into chunks of n size.
splitIntoN(List ls, int n) {
  List nLs = [];
  List x = [];
  for (var i in ls) {
    if (x.length >= n) {
      nLs.add(List.from(x));
      x.clear();
    } else {
      x.add(i);
    }
  }
  nLs.add(List.from(x));
  return nLs;
}

// 	33.	Find difference between two lists.
findDifference(List a, List b) {
  List a1 = a
      .where(
        (element) => !b.contains(element),
      )
      .toList();
  List b1 = b
      .where(
        (element) => !a.contains(element),
      )
      .toList();
  return [...a1, ...b1];
}

// 	34.	Convert a list to a map (with index as key).
convertLs(List ls) {
  Map map = {};
  for (int i = 0; i < ls.length; i++) map[i] = ls[i];
  return map;
}

// 	35.	Extract only unique values from a list of maps.

// 	36.	Group a list of items by property (like category).
// 	37.	Sort list of maps by a specific key.
// 	38.	Partition a list into even and odd indexed groups.
// 	39.	Implement your own version of .map() and .filter().
// 	40.	Remove all elements that appear more than once.

// ⸻

// 🧱 3. Maps & Sets
// 	41.	Swap keys and values in a map.
swapmap(Map map) {
  Map swap = {};
  for (var item in map.entries) {
    swap[item.value] = item.key;
  }
  return swap;
}

// 	42.	Merge two maps (with overlapping keys).
mergeMaps(Map a, Map b) {
  return {...a, ...b};
}

// 	43.	Sort a map by its values.
sortMap(Map map) {
  return Map.fromEntries(map.entries.toList()
    ..sort(
      (a, b) => a.value.compareTo(b.value),
    ));
}

// 	44.	Convert list of pairs to a map.
listofPairToMap(List<List> ls) {
  var map = {};
  for (List a in ls) {
    if (a.length > 1) {
      map[a[0]] = a[1];
    }
  }
  return map;
}

// 	45.	Filter map entries by value.
Map filterMapByValue(Map map, bool Function(dynamic value) condition) {
  return Map.fromEntries(
    map.entries.where((entry) => condition(entry.value)),
  );
}

// 	46.	Count word frequency in a sentence using a map.
// 	47.	Create a read-only map and demonstrate immutability.
Map readOnly(Map map) => Map.unmodifiable(map);

// 	48.	Check if two maps are equal.
bool isMapEqual(Map a, Map b) => MapEquality().equals(a, b);
// 	49.	Remove null values from a map.
Map removeNull(Map map) => Map.fromEntries(map.entries.where(
      (element) => element.value != null,
    ));
// 	50.	Invert nested maps (key-value reversal).

// ⸻

// 🧍‍♂️ 4. OOP (Classes, Inheritance, Encapsulation)
// 	51.	Create a class User with private fields and getter/setter.
class User {
  String _name;
  String _surname;
  User(this._name, this._surname);

  String get name => _name;
  String get surname => _surname;
  set name(String value) {
    _name = value;
  }

  set surname(String value) {
    _surname = value;
  }
}

// 	52.	Implement inheritance between Shape, Circle, and Rectangle.
class Shape {
  double area() {
    return 0.0;
  }
}

class Circle extends Shape {
  double radius;
  Circle(this.radius);
  @override
  double area() {
    return 3.1416 * radius * radius;
  }
}

class Rectangle extends Shape {
  double length;
  double breath;
  Rectangle(this.breath, this.length);
  @override
  double area() {
    return length * breath;
  }
}

// 	53.	Use abstract classes and implement their methods.
abstract class shape1 {
  double area();
}

class circle1 extends shape1 {
  double radius;
  circle1(this.radius);
  @override
  double area() {
    return 3.14 * radius * radius;
  }
}

// 	54.	Implement an interface manually using implements.
class Animal {
  canSpeak() {}
  canEat() {}
}

class Dog implements Animal {
  @override
  canEat() {
    print('Dog bark');
  }

  @override
  canSpeak() {
    print('Dog eat');
  }
}

// 	55.	Demonstrate method overriding and super.
class Vechile {
  void start() {
    print('vechile start');
  }

  void stop() {
    print('vechile stop');
  }
}

class Car extends Vechile {
  @override
  void start() {
    super.start();
    print('to start');
  }
}

// 	56.	Use factory constructors for caching instances.
class DBConnection {
  final String dbName;
  DBConnection._internal(this.dbName);
  static final Map<String, DBConnection> _cache = {};
  factory DBConnection(String dbName) {
    if (_cache.containsKey(dbName)) {
      return _cache[dbName]!;
    }
    final connection = DBConnection._internal(dbName);
    _cache[dbName] = connection;
    return connection;
  }
}

// 	57.	Implement a Singleton class in Dart.
class MySingleTon {
  MySingleTon._internal();
  static final _instance = MySingleTon._internal();
  factory MySingleTon() => _instance;
}

class MySingle {
  MySingle._internal();
  static final _instan = MySingle._internal();
  factory MySingle() => _instan;
}

// 	58.	Create a copyWith() method in a model class.
class User1 {
  String? name;
  String? email;
  User1(this.email, this.name);
  coptWith(String? name, String? email) {
    return User1(name, email);
  }

  @override
  String toString() {
    return "name : $name, email :$email";
  }
}

// 	59.	Implement equality (==) and hashCode in a class.
// 	60.	Build a class hierarchy for a Vehicle system (Car, Bike, Truck).

// ⸻

// 🔄 5. Functional Programming
// 	61.	Use .map() to transform a list of users into names.
List<String> userName(List<User> ls) {
  return ls
      .map(
        (e) => e._name,
      )
      .toList();
}

// 	62.	Chain .where() and .map() to filter and modify data.
// 	63.	Use .fold() to concatenate strings.
createConcentrateString(List<String> item) {
  item.fold('', (a, b) => "$a $b");
}

// 	64.	Use .reduce() to find the longest word.
findLongest(List<String> words) {
  String word = words.reduce(
    (a, b) => a.length > b.length ? a : b,
  );
  return word;
}
// 	65.	Implement your own higher-order function that takes a function as argument.
// 	66.	Demonstrate function currying in Dart.
// 	67.	Create a custom iterable that generates IDs.
// 	68.	Write a function returning another function (closure).
// 	69.	Implement caching with a closure.
// 	70.	Use List.generate() creatively to build structured data.

// ⸻

// 🕓 6. Async & Futures
// 	71.	Simulate network delay using Future.delayed().
// 	72.	Implement a function that fetches multiple async tasks in parallel.
Future a() async {}
Future b() async {}
Future c() async {}
Future d() async {
  await Future.wait([a(), b(), c()]);
}

// 	73.	Use await Future.wait() for multiple futures.
// 	74.	Implement retry logic for a failed network call.
// 	75.	Use Stream.periodic() to emit values at intervals.
Stream<int> numberStream() {
  return Stream.periodic(Duration(seconds: 1), (count) => count + 1);
}

void main2() {
  numberStream().take(5).listen((value) {
    print("Value: $value");
  });
  countdown(5).listen(
    (value) {
      print("⏱ $value seconds remaining");
    },
  ).onDone(
    () {
      print("🚀 Time's up!");
    },
  );
}

// 	76.	Create a countdown timer using Stream.
Stream<int> countdown(int sec) async* {
  for (int i = sec; i >= 0; i--) {
    yield i;
    await Future.delayed(Duration(seconds: 1));
  }
}

// 	77.	Use async* and yield to emit multiple results.
// 	78.	Handle a stream error gracefully.
// 	79.	Combine two streams into one.
// 	80.	Implement a fake API call returning JSON and parse it.
// create Singleton class
class MyClass {
  MyClass._internal();
  static final MyClass _instancs = MyClass._internal();
  factory MyClass() => _instancs;
  // Example property
}

class My {
  My._int();
  static final inter = My._int();
  factory My() => inter;
}
// ⸻

// 📦 7. Files & JSON
// 	81.	Read a local JSON string and convert it to a Dart object.
// 	82.	Serialize a Dart object to JSON.
// 	83.	Write JSON data to a file.
writeDate() async {
  final user = {"id": 1, "name": "Neelesh"};
  final file = File('user.json');

  await file.writeAsString(jsonEncode(user));
  print("✅ JSON written to user.json");
}

// 	84.	Parse nested JSON into a Dart model.
class Address {
  String city;
  String houseno;
  Address(this.city, this.houseno);
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(json['city'], json['houseno']);
  }
  Map<String, dynamic> toJson() {
    return {'city': city, 'houseno': houseno};
  }
}

class Person {
  String name;
  Address address;
  Person(this.address, this.name);
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(Address.fromJson(json['address']), json['name']);
  }
  Map<String, dynamic> toJson() {
    return {'name': name, 'address': address.toJson()};
  }
}

class School {
  String name;
  String add;
  Person person;
  School(this.name, this.add, this.person);
  factory School.fromJson(Map<String, dynamic> json) {
    return School(json['name'], json['add'], Person.fromJson(json['person']));
  }
  tojson() {
    return {"name": name, "add": add}; 
  }
}
// 	85.	Pretty-print JSON data.
// 	86.	Remove null or empty fields from a JSON map.
// 	87.	Deep clone a JSON map.
// 	88.	Flatten a nested JSON structure.
// 	89.	Merge two JSON objects.
// 	90.	Convert a list of maps into a single combined map.

// ⸻

// ⚙️ 8. General / Logic-Based
// 	91.	Implement a simple LRU cache.
// 	92.	Build a simple dependency injector.
// 	93.	Create a logger with levels (info, debug, error).
// 	94.	Debounce a function (limit frequency of execution).
// 	95.	Throttle a function.
// 	96.	Implement a retry mechanism with exponential backoff.
// 	97.	Create a simple in-memory database class.
// 	98.	Build a state management pattern with ValueNotifier.
// 	99.	Implement an event bus in Dart.
// 	100.	Write a mock NetworkManager that queues API requests until network reconnects.

// ⸻
