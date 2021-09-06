import '../base_model.dart';

// This is a response provided by Firebase for adding an object to a node.
// It is shared model and currently utilized for add product & order.
class AddResponse implements BaseModel {
  String? id;

  AddResponse({this.id});

  factory AddResponse.fromJson(Map<String, dynamic> json) {
    return AddResponse(id: json['name']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'name': id};
  }
}