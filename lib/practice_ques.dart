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

  List lsVOw = ['a', 'e', 'i', '0', 'u'];
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
    return a.join('');
  }
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
// 	14.	Remove specific characters from a string.
// 	15.	Swap case of each character (upper ↔ lower).
// 	16.	Count digits, letters, and special symbols in a string.
// 	17.	Check if two strings are rotations of each other.
// 	18.	Remove HTML tags from a string.
// 	19.	Extract all URLs from a text.
// 	20.	Mask part of a string (e.g., email masking).

// ⸻

// 📋 2. Lists & Collections
// 	21.	Remove duplicates from a list.
// 	22.	Find the second largest element in a list.
// 	23.	Merge two sorted lists.
// 	24.	Rotate a list left/right by n positions.
// 	25.	Move all zeros to the end of a list.
// 	26.	Reverse a list in place.
// 	27.	Flatten a nested list.
// 	28.	Count frequency of elements in a list.
// 	29.	Get common elements between two lists.
// 	30.	Remove all falsy/null/empty values from a list.
// 	31.	Shuffle a list randomly.
// 	32.	Split a list into chunks of n size.
// 	33.	Find difference between two lists.
// 	34.	Convert a list to a map (with index as key).
// 	35.	Extract only unique values from a list of maps.
// 	36.	Group a list of items by property (like category).
// 	37.	Sort list of maps by a specific key.
// 	38.	Partition a list into even and odd indexed groups.
// 	39.	Implement your own version of .map() and .filter().
// 	40.	Remove all elements that appear more than once.

// ⸻

// 🧱 3. Maps & Sets
// 	41.	Swap keys and values in a map.
// 	42.	Merge two maps (with overlapping keys).
// 	43.	Sort a map by its values.
// 	44.	Convert list of pairs to a map.
// 	45.	Filter map entries by value.
// 	46.	Count word frequency in a sentence using a map.
// 	47.	Create a read-only map and demonstrate immutability.
// 	48.	Check if two maps are equal.
// 	49.	Remove null values from a map.
// 	50.	Invert nested maps (key-value reversal).

// ⸻

// 🧍‍♂️ 4. OOP (Classes, Inheritance, Encapsulation)
// 	51.	Create a class User with private fields and getter/setter.
// 	52.	Implement inheritance between Shape, Circle, and Rectangle.
// 	53.	Use abstract classes and implement their methods.
// 	54.	Implement an interface manually using implements.
// 	55.	Demonstrate method overriding and super.
// 	56.	Use factory constructors for caching instances.
// 	57.	Implement a Singleton class in Dart.
// 	58.	Create a copyWith() method in a model class.
// 	59.	Implement equality (==) and hashCode in a class.
// 	60.	Build a class hierarchy for a Vehicle system (Car, Bike, Truck).

// ⸻

// 🔄 5. Functional Programming
// 	61.	Use .map() to transform a list of users into names.
// 	62.	Chain .where() and .map() to filter and modify data.
// 	63.	Use .fold() to concatenate strings.
// 	64.	Use .reduce() to find the longest word.
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
// 	73.	Use await Future.wait() for multiple futures.
// 	74.	Implement retry logic for a failed network call.
// 	75.	Use Stream.periodic() to emit values at intervals.
// 	76.	Create a countdown timer using Stream.
// 	77.	Use async* and yield to emit multiple results.
// 	78.	Handle a stream error gracefully.
// 	79.	Combine two streams into one.
// 	80.	Implement a fake API call returning JSON and parse it.

// ⸻

// 📦 7. Files & JSON
// 	81.	Read a local JSON string and convert it to a Dart object.
// 	82.	Serialize a Dart object to JSON.
// 	83.	Write JSON data to a file.
// 	84.	Parse nested JSON into a Dart model.
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
