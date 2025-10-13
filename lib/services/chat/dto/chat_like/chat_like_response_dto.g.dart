// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_like_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatLikeResponseDto _$ChatLikeResponseDtoFromJson(Map<String, dynamic> json) =>
    ChatLikeResponseDto(
      isLiked: json['isLiked'] as bool,
      totalLikes: json['totalLikes'] as int,
    );

Map<String, dynamic> _$ChatLikeResponseDtoToJson(
        ChatLikeResponseDto instance) =>
    <String, dynamic>{
      'isLiked': instance.isLiked,
      'totalLikes': instance.totalLikes,
    };
