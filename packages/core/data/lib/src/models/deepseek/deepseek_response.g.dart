// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deepseek_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeepSeekResponse _$DeepSeekResponseFromJson(Map<String, dynamic> json) =>
    DeepSeekResponse(
      choices: (json['choices'] as List<dynamic>)
          .map((e) => DeepSeekChoiceDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DeepSeekResponseToJson(DeepSeekResponse instance) =>
    <String, dynamic>{'choices': instance.choices};
