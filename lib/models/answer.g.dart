// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Answer _$AnswerFromJson(Map<String, dynamic> json) => _Answer(
  text: json['text'] as String,
  scores: Map<String, int>.from(json['scores'] as Map),
);

Map<String, dynamic> _$AnswerToJson(_Answer instance) => <String, dynamic>{
  'text': instance.text,
  'scores': instance.scores,
};
