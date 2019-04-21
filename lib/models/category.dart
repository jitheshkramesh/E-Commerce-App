class CategoryData {
  final String id;
  //String catId;
  String catDesc;
  bool catIsActive;
  String imagePath;
  final String image;
  final String userEmail;
  final String userId;
  CategoryData(
      {
      //this.catId,
      this.catDesc,
      this.catIsActive,
      this.imagePath,
      this.image,
      this.userEmail,
      this.userId,
      this.id});
  factory CategoryData.fromJson(Map<String, dynamic> parsedJson) {
    return CategoryData(
        //catId: parsedJson["CatId"],
        catDesc: parsedJson["CatDesc"],
        catIsActive: parsedJson["CatIsActive"] ? true : false,
        imagePath: parsedJson["imagePath"],
        image: parsedJson["ImageUrl"],
        userEmail: parsedJson["UserEmail"],
        userId: parsedJson["UserId"]);
  }
}
