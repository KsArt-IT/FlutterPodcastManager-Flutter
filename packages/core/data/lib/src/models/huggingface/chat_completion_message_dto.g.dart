// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_completion_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatCompletionMessageDto _$ChatCompletionMessageDtoFromJson(
  Map<String, dynamic> json,
) => ChatCompletionMessageDto(
  role: json['role'] as String,
  content: json['content'] as String,
);

Map<String, dynamic> _$ChatCompletionMessageDtoToJson(
  ChatCompletionMessageDto instance,
) => <String, dynamic>{'role': instance.role, 'content': instance.content};
