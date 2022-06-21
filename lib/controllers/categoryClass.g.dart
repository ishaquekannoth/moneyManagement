// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categoryModelClass.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryClassAdapter extends TypeAdapter<CategoryModelClass> {
  @override
  final int typeId = 1;

  @override
  CategoryModelClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryModelClass(
      name: fields[1] as String,
    )..item = (fields[0] as List?)?.cast<DropdownMenuItem<String>>();
  }

  @override
  void write(BinaryWriter writer, CategoryModelClass obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.item)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
