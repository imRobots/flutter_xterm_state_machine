class Range {
  final int start;
  final int end;

  Range(this.start, this.end);

  List<int> toList() {
    return List<int>.generate(end - start + 1, (index) => start + index);
  }
}
