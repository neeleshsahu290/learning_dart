// Dart solutions for 20 coding problems

// Easy

// 1. Reverse words in a string
String reverseWords(String str) => str.split(' ').reversed.join(' ');

// 2. Check if a string is a palindrome
bool isPalindrome(String str) => str == str.split('').reversed.join('');

// 3. Move all zeros to the end of the array
List<int> moveZerosToEnd(List<int> arr) {
  List<int> result = arr.where((x) => x != 0).toList();
  int zeroCount = arr.length - result.length;
  result.addAll(List.filled(zeroCount, 0));
  return result;
}

// 4. Find duplicates in an array
List<int> findDuplicates(List<int> arr) {
  Map<int, int> count = {};
  List<int> duplicates = [];
  for (var num in arr) {
    count[num] = (count[num] ?? 0) + 1;
    if (count[num] == 2) duplicates.add(num);
  }
  return duplicates;
}

// 5. Find the first non-repeating character in a string
String firstNonRepeating(String str) {
  Map<String, int> count = {};
  for (var ch in str.split('')) count[ch] = (count[ch] ?? 0) + 1;
  for (var ch in str.split('')) {
    if (count[ch] == 1) return ch;
  }
  return '';
}

// 6. Count frequency of elements in an array
Map<int, int> countFrequency(List<int> arr) {
  Map<int, int> freq = {};
  for (var num in arr) freq[num] = (freq[num] ?? 0) + 1;
  return freq;
}

// 7. Check if two strings are anagrams
bool areAnagrams(String s1, String s2) {
  var a = s1.split('')..sort();
  var b = s2.split('')..sort();
  return a.join() == b.join();
}

// 8. Merge two sorted arrays
List<int> mergeSorted(List<int> a, List<int> b) {
  List<int> merged = [];
  int i = 0, j = 0;
  while (i < a.length && j < b.length) {
    if (a[i] < b[j]) merged.add(a[i++]);
    else merged.add(b[j++]);
  }
  while (i < a.length) merged.add(a[i++]);
  while (j < b.length) merged.add(b[j++]);
  return merged;
}

// 9. Find all pairs with a given sum
List<List<int>> pairsWithSum(List<int> arr, int target) {
  List<List<int>> res = [];
  Set<int> seen = {};
  for (var num in arr) {
    int complement = target - num;
    if (seen.contains(complement)) res.add([complement, num]);
    seen.add(num);
  }
  return res;
}

// 10. Rotate an array by k positions
List<int> rotateArray(List<int> arr, int k) {
  int n = arr.length;
  k %= n;
  return arr.sublist(n - k) + arr.sublist(0, n - k);
}

// Medium

// 11. Maximum product subarray
int maxProduct(List<int> nums) {
  int maxProd = nums[0], minProd = nums[0], result = nums[0];
  for (int i = 1; i < nums.length; i++) {
    if (nums[i] < 0) {
      int temp = maxProd;
      maxProd = minProd;
      minProd = temp;
    }
    maxProd = [nums[i], maxProd * nums[i]].reduce((a, b) => a > b ? a : b);
    minProd = [nums[i], minProd * nums[i]].reduce((a, b) => a < b ? a : b);
    result = result > maxProd ? result : maxProd;
  }
  return result;
}

// 12. Longest substring without repeating characters
int lengthOfLongestSubstring(String s) {
  Map<String, int> lastIndex = {};
  int maxLength = 0, start = 0;
  for (int end = 0; end < s.length; end++) {
    if (lastIndex.containsKey(s[end])) start = (start > lastIndex[s[end]]! + 1) ? start : lastIndex[s[end]]! + 1;
    maxLength = maxLength > end - start + 1 ? maxLength : end - start + 1;
    lastIndex[s[end]] = end;
  }
  return maxLength;
}

// 13. String compression
String compressString(String s) {
  if (s.isEmpty) return s;
  StringBuffer sb = StringBuffer();
  int count = 1;
  for (int i = 1; i <= s.length; i++) {
    if (i < s.length && s[i] == s[i - 1]) count++;
    else {
      sb.write(s[i - 1] + count.toString());
      count = 1;
    }
  }
  return sb.toString();
}

// 14. Intersection of two arrays
List<int> intersection(List<int> a, List<int> b) {
  Set<int> setA = a.toSet();
  Set<int> setB = b.toSet();
  return setA.intersection(setB).toList();
}

// 15. Maximum subarray sum (Kadane’s algorithm)
int maxSubArray(List<int> nums) {
  int maxSoFar = nums[0], maxEndingHere = nums[0];
  for (int i = 1; i < nums.length; i++) {
    maxEndingHere = (nums[i] > maxEndingHere + nums[i]) ? nums[i] : maxEndingHere + nums[i];
    maxSoFar = (maxSoFar > maxEndingHere) ? maxSoFar : maxEndingHere;
  }
  return maxSoFar;
}

// Tough

// 16. Longest palindromic substring
String longestPalindrome(String s) {
  if (s.isEmpty) return '';
  int start = 0, end = 0;
  for (int i = 0; i < s.length; i++) {
    int len1 = expandFromCenter(s, i, i);
    int len2 = expandFromCenter(s, i, i + 1);
    int len = len1 > len2 ? len1 : len2;
    if (len > end - start) {
      start = i - (len - 1) ~/ 2;
      end = i + len ~/ 2;
    }
  }
  return s.substring(start, end + 1);
}

int expandFromCenter(String s, int left, int right) {
  while (left >= 0 && right < s.length && s[left] == s[right]) {
    left--;
    right++;
  }
  return right - left - 1;
}

// 17. Minimum window substring
String minWindow(String s, String t) {
  if (s.isEmpty || t.isEmpty) return '';
  Map<String, int> tFreq = {}; 
  for (var ch in t.split('')) tFreq[ch] = (tFreq[ch] ?? 0) + 1;
  int required = tFreq.length;
  int left = 0, right = 0, formed = 0;
  Map<String,int> windowCounts = {};
  int minLen = 1<<30, minLeft = 0;

  while (right < s.length) {
    String ch = s[right];
    windowCounts[ch] = (windowCounts[ch] ?? 0) + 1;
    if (tFreq.containsKey(ch) && windowCounts[ch] == tFreq[ch]) formed++;

    while (left <= right && formed == required) {
      if (right - left + 1 < minLen) {
        minLen = right - left + 1;
        minLeft = left;
      }
      String leftCh = s[left];
      windowCounts[leftCh] = windowCounts[leftCh]! - 1;
      if (tFreq.containsKey(leftCh) && windowCounts[leftCh]! < tFreq[leftCh]!) formed--;
      left++;
    }
    right++;
  }
  return minLen == 1<<30 ? '' : s.substring(minLeft, minLeft + minLen);
}

// 18. Word break problem
bool wordBreak(String s, List<String> wordDict) {
  Set<String> wordSet = wordDict.toSet();
  List<bool> dp = List.filled(s.length + 1, false);
  dp[0] = true;
  for (int i = 1; i <= s.length; i++) {
    for (int j = 0; j < i; j++) {
      if (dp[j] && wordSet.contains(s.substring(j, i))) {
        dp[i] = true;
        break;
      }
    }
  }
  return dp[s.length];
}

// 19. Longest substring with at most K distinct characters
int lengthOfLongestKDistinct(String s, int k) {
  Map<String,int> count = {};
  int left = 0, maxLen = 0;
  for (int right = 0; right < s.length; right++) {
    count[s[right]] = (count[s[right]] ?? 0) + 1;
    while (count.length > k) {
      count[s[left]] = count[s[left]]! - 1;
      if (count[s[left]] == 0) count.remove(s[left]);
      left++;
    }
    maxLen = maxLen > right - left + 1 ? maxLen : right - left + 1;
  }
  return maxLen;
}

// 20. Sliding window maximum
List<int> maxSlidingWindow(List<int> nums, int k) {
  List<int> res = [];
  List<int> deque = [];
  for (int i = 0; i < nums.length; i++) {
    while (deque.isNotEmpty && deque.first <= i - k) deque.removeAt(0);
    while (deque.isNotEmpty && nums[deque.last] < nums[i]) deque.removeLast();
    deque.add(i);
    if (i >= k - 1) res.add(nums[deque.first]);
  }
  return res;
}