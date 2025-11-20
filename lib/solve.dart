
void main() {
  Future(() {
    print('#1');
  });
  Future.sync(() {
    print('#2');
  });
  print('#3');
}