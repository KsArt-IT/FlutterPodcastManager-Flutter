import 'package:json_annotation/json_annotation.dart';

part 'chat_completion_message_dto.g.dart';

@JsonSerializable()
class ChatCompletionMessageDto {
  final String role;
  final String content;

  ChatCompletionMessageDto({required this.role, required this.content});

  factory ChatCompletionMessageDto.fromJson(Map<String, dynamic> json) =>
      _$ChatCompletionMessageDtoFromJson(json);
}
