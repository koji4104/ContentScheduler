class ProgressData {
  String name = "";
  double total = 1;
  double value = 0;
  int col = 0xFF000000;
  ProgressData({String? name, double? value, double? total, int? col}) {
    if(name != null) this.name = name;
    if(value != null) this.value = value;
    if(total != null) this.total = total;
    if(col != null) this.col = col;
  }
}