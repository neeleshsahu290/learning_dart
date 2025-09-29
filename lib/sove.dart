// Easy:
// 	1.	Reverse words in a string.
import 'dart:collection';


String reverseWords(String word) {
  return word.split("").reversed.join("");
}

// 	2.	Check if a string is a palindrome.
bool isPalindrome(String str) {
  var reverseStr = str.split("").reversed.join("");
  return reverseStr == str;
}

// 	3.	Move all zeros to the end of the array.
List<int> moveZerosEnd(List<int> list) {
  var resultList = list.where((x) => x != 0).toList();
  int zeroCount = list.length - resultList.length;
  resultList.addAll(List.filled(zeroCount, 0));
  return resultList;
}

// 	4.	Find duplicates in an array.
List<int> duplicateInt(List<int> list) {
  Map<int, int> map = {};
  List<int> duplicates = [];
  for (int i in list) {
    map[i] = map[i] != null ? (map[i]! + 1) : 1;
    if (map[i]! > 1) {
      duplicates.add(i);
    }
  }
  return duplicates;
}

// 	5.	Find the first non-repeating character in a string.
String? firstNonRepatingChar(String str) {
  Map char = {};
  List<String> charList = str.split("").toList();
  for (var ch in charList) char[ch] = (char[ch] ?? 0) + 1;
  for (var ch in charList) {
    if (char[ch] == 1) {
      return ch;
    }
  }
  return null;
}

// 	6.	Count frequency of elements in an array.
Map findFreqChar(String str) {
  Map char = {};
  for (var ch in str.split("")) char[ch] = (char[ch] ?? 0) + 1;
  return char;
}

// 	7.	Check if two strings are anagrams.
bool isAnagrams(String str1, String str2) {
  List<String> chars = str1.split('');
  chars.sort(); // sort modifies in place
  String sortedString = chars.join();
  List<String> char2 = str2.split('');
  char2.sort();
  String sortedString2 = char2.join('');
  return sortedString == sortedString2;
}

// 	8.	Merge two sorted arrays.
List mergeSorted(List arr1, List arr2) {
  return [...arr1, ...arr2]..sort();
}

// 	9.	Find all pairs with a given sum.

// 	10.	Rotate an array by k positions.
List? rotateArr(List arr, int postion) {
  if (postion > arr.length - 1) return null;
  if (postion == 0) return arr;
  List rotatedArr = [];
  List initList = [];
  for (var i = 0; i < arr.length - 1; i++) {
    if (i >= postion) {
      rotatedArr.add(arr[i]);
    } else {
      initList.add(arr[i]);
    }
  }
  rotatedArr.addAll(initList);
  return (rotatedArr);
}

// Medium:
// 11. Maximum product subarray.
int maxProdSubArr(List arr) {
  int maxProd = arr.first;
  for (var num in arr) {
    var value = num * maxProd;
    if (value > maxProd) {
      maxProd = value;
    }
  }
  return maxProd;
}

// 12. Longest substring without repeating characters.
String longSubStr(String str) {
  List<String> list1 = [];
  List<List<String>> subStr = [];

  for (var ch in str.split('')) {
    if (!list1.contains(ch)) {
      list1.add(ch);
    } else {
      // store a copy instead of reference
      subStr.add(List.from(list1));

      // reset list1 properly: start fresh from duplicate's next
      int dupIndex = list1.indexOf(ch);
      list1 = list1.sublist(dupIndex + 1);
      list1.add(ch);
    }
  }

  // add the last collected substring
  if (list1.isNotEmpty) subStr.add(List.from(list1));

  // find longest
  List<String> longest = [];
  for (var ls in subStr) {
    if (ls.length > longest.length) {
      longest = ls;
    }
  }

  return longest.join("");
}

// 13. String compression.
compressedStr(String str) {
  String compressed = "";
  int count = 0;

  for (var ch in str.split('')) {}
}
// 14. Intersection of two arrays.

// 15. Maximum subarray sum (Kadane’s algorithm).

// Tough:
// 16. Longest palindromic substring.
// 17. Minimum window substring.
// 18. Word break problem.
// 19. Longest substring with at most K distinct characters.
// 20. Sliding window maximum.

// 2. Linked Lists

// Easy:
// 21. Reverse a linked list.
List reverseList(List ls) {
  return ls.reversed.toList();
}

// 22. Find the middle of a linked list.
int middleElement(List<int> ls) {
  int ln = ls.length;
  return ls[(ln - 1) ~/ 2];
}

// 23. Remove N-th node from the end.
List<int> removeNth(List<int> ls, int k) {
  if (k > ls.length - 1) return ls;
  ls.removeAt(k);
  return ls;
}

// 24. Merge two sorted linked lists.
List mergeList(List ls1, ListBase ls2) {
  return [...ls1, ...ls2];
}

// Medium:
// 25. Detect a cycle in a linked list.
// 26. Check if a linked list is a palindrome.
bool isPalidromeList(List ls) {
  List revered = ls.reversed.toList();
  for (int i = 0; i < ls.length; i++) {
    if (ls[i] != revered[i]) return false;
  }
  return true;
}

// 27. Add two numbers represented by linked lists.
int addTwoNumberFromList(List<int> ls1, List<int> ls2) {
  int num1 = 0;
  for (int num in ls1) {
    num1 = num1 * 10 + num;
  }
  int num2 = 0;
  for (int num in ls2) {
    num2 = num2 * 10 + num;
  }
  return num1 + num2;
}

// Tough:
// 28. Flatten a multilevel linked list.
// 29. Copy a linked list with random pointers.
// 30. Intersection point of two linked lists.

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

// 4. Dynamic Programming (DP)

// Easy:
// 46. Fibonacci numbers.
int fibonacciNum(int n) {
  int a = 0;
  int b = 1;
  for (int i = 0; i < n; i++) {
    int c = a + b;
    a = b;
    b = c;
  }
  return b;
}
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
int biarySearch(List<int> ls, int target) {
  ls.sort();
  int low = 0;
  int high = ls.length - 1;
  while (low <= high) {
    int mid = (low + high) ~/ 2;
    if (ls[mid] == target) {
      return mid;
    } else if (ls[mid] < target) {
      low = mid + 1;
    } else {
      high = mid - 1; // search left
    }
  }
  return -1;
}

// 83. Merge sort and quick sort.
// 84. Find peak element in array.
int peakElementBinarySearch(List<int> ls) {
  ls.sort();
  int low = 0, high = ls.length - 1;
  while (low <= high) {
    int mid = low + high ~/ 2;
    if (ls[mid] < ls[mid + 1]) {
      low = mid + 1;
    } else {
      high = mid;
    }
  }
  return ls[low];
}
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
int reverseInt(int num) {
  return int.parse(num.toString().split('').reversed.join(""));
}
// 93. Check if a number is power of two.

// 94. Count set bits in an integer.
// 95. Find missing number in array 1..N.
int? findMissingNum(List<int> numArr) {
  for (int i = 1; i < numArr.length + 1; i++) {
    if (numArr != i) {
      return i;
    }
  }
  return null;
}

// Medium:
// 96. Single number (all elements appear twice except one).
// 97. Add two numbers without using + or -.

// 98. Multiply two numbers without using *.
multiplyWithoutSymbol(int num1, int num2) {
  for (int i = 1; i < num1; i++) {
    num2 = num2 + num1;
  }
}

// Tough:
// 99. Detect if a number is a palindrome.
bool isPalidomeNumber(int num) {
  return num == int.parse(num.toString().split("").reversed.join(""));
}

// 100. XOR of all numbers from 1 to N.
// 101. Divide two integers without using / operator.
