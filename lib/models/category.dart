class CategoryData {
  int catId;
  String catDesc;
  String catIsActive;
  CategoryData({this.catId, this.catDesc, this.catIsActive});
  factory CategoryData.fromJson(Map<String, dynamic> parsedJson) {
    return CategoryData(
        catId: parsedJson["CatId"],
        catDesc: parsedJson["CatDesc"],
        catIsActive: parsedJson["CatIsActive"]);
  }
}
