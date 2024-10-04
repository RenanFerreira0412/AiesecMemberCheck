class Experience {
  final String title;
  bool isChecked;

  Experience({required this.title, this.isChecked = false});

  void toggleCheck() {
    isChecked = !isChecked;
  }
}
