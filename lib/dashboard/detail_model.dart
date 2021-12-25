
class DetailData {
  String name = "";
  String date = "";
  String size = "";

  DetailData({String? name, String? date, String? size}) {
    if(name != null) this.name = name;
    if(date != null) this.date = date;
    if(size != null) this.size = size;
  }
}
