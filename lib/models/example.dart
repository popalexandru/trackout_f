import 'package:trackout_f/models/repetition.dart';

class Example{
  String id;
  String name;
  String description;
  String image;

  Example(
      this.id,
      this.name,
      this.description,
      this.image
      );

  factory Example.fromJson(dynamic json){
    return Example(
      json['id'],
      json['name'],
      json['description'],
      json['image']
    );
  }
}