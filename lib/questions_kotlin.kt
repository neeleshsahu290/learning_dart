

// check the sum of two array makes the target
List<int> twoSum(List<int> numbers, int target) {
  int l = 0, r = numbers.length - 1; // two pointers
  
  while (l < r) {
    int sum = numbers[l] + numbers[r];
    if (sum == target) return [l + 1, r + 1]; // found solution
    sum < target ? l++ : r--; // adjust pointers
  }
  return [-1, -1]; // not found
}

fun twoSum(numbers: IntArray, target: Int): IntArray {
    var l = 0
    var r = numbers.size - 1 // two pointers

    while (l < r) {
        val sum = numbers[l] + numbers[r]
        if (sum == target) {
            return intArrayOf(l + 1, r + 1) // found solution (1-based indices)
        }
        if (sum < target) {
            l++ // sum too small → move left pointer right
        } else {
            r-- // sum too big → move right pointer left
        }
    }
    return intArrayOf(-1, -1) // not found
}