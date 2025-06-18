// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_choice_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatChoiceDto _$ChatChoiceDtoFromJson(Map<String, dynamic> json) =>
    ChatChoiceDto(
      message: ChatCompletionMessageDto.fromJson(
        json['message'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ChatChoiceDtoToJson(ChatChoiceDto instance) =>
    <String, dynamic>{'message': instance.message};
