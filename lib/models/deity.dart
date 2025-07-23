import 'package:flutter/material.dart';

class Deity {
  final String id;
  final String name;
  final String title;
  final String icon;
  final Map<String, int> traits;
  final String description;
  final String dailyChallenge;
  final List<Color> colors;

  const Deity({
    required this.id,
    required this.name,
    required this.title,
    required this.icon,
    required this.traits,
    required this.description,
    required this.dailyChallenge,
    required this.colors,
  });

  // Conversion vers JSON pour persistence future
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'traits': traits,
      'description': description,
      'dailyChallenge': dailyChallenge,
    };
  }

  // Création depuis JSON
  factory Deity.fromJson(Map<String, dynamic> json, String icon, List<Color> colors) {
    return Deity(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      icon: icon,
      traits: Map<String, int>.from(json['traits']),
      description: json['description'],
      dailyChallenge: json['dailyChallenge'],
      colors: colors,
    );
  }
}