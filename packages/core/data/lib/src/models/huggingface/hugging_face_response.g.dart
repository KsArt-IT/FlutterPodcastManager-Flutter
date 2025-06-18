// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hugging_face_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HuggingFaceResponse _$HuggingFaceResponseFromJson(Map<String, dynamic> json) =>
    HuggingFaceResponse(
      choices: (json['choices'] as List<dynamic>)
          .map((e) => ChatChoiceDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HuggingFaceResponseToJson(
  HuggingFaceResponse instance,
) => <String, dynamic>{'choices': instance.choices};
