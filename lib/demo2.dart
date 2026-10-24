void main() async{
  print("line 1");
  print(display());
  print("line 3");
}
Future<String> display() async{
  await Future.delayed(Duration(seconds: 5));
  return "object";
}