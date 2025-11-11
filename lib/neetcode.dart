//Given an integer array nums, return true if any value appears more than once in the array, otherwise return false.
bool checkDuplicates(List<int> num) {
  Set<int> a = num.toSet();

  return a.length != num.length;
}


checkAnagrams(String a, String b) {
  if (a.length != b.length) {
    return false;
  }
  var a1 = (a.split("")..sort()).join("");
  var b1 = (b.split("")..sort()).join("");
  return (a1 == b1);
}

void main() {
  var dup = checkDuplicates([1, 2, 3, 4, 3]);
  print(dup);
}
