// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tree_decoration_save_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TreeDecorationSaveDto _$TreeDecorationSaveDtoFromJson(
        Map<String, dynamic> json) =>
    TreeDecorationSaveDto(
      selectedFruitIds: (json['selectedFruitIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      selectedFlowerIds: (json['selectedFlowerIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TreeDecorationSaveDtoToJson(
        TreeDecorationSaveDto instance) =>
    <String, dynamic>{
      'selectedFruitIds': instance.selectedFruitIds,
      'selectedFlowerIds': instance.selectedFlowerIds,
    };
