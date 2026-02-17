class Language{
  String language;
  String code;
  String imageSrc;
  Language(this.language,this.code,this.imageSrc);

  Map toJson()=>{
    "language":language,
    "code":code,
    "imageSrc":imageSrc
  };
}