List<String> getYears() {
  List<String> years = [];
  DateTime hoje = DateTime.now();
  int actualYear = hoje.year;

  for (int i = 0; i < 4; i++) {
    years.add((actualYear - i).toString());
  }

  return years;
}
