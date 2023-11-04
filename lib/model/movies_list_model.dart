class MoviesListModel {
  List<Results>? results;
  int? page;
  int? totalPages;
  int? totalResults;

  MoviesListModel({results, page, totalPages, totalResults});

  MoviesListModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
    page = json['page'];
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['page'] = page;
    data['total_pages'] = totalPages;
    data['total_results'] = totalResults;
    return data;
  }
}

class Results {
  int? id;
  bool? adult;

  Results({id, adult});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adult = json['adult'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['adult'] = adult;
    return data;
  }
}
