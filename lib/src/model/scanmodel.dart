
class ScanModel {
    ScanModel({
        this.id,
        this.url,
        this.titulo,
    });

    int id;
    String url;
    String titulo;

    factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        titulo: json["titulo"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "titulo": titulo
        ,
    };
}
