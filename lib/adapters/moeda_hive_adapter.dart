import 'package:hive/hive.dart';
import 'package:teste_1/models/moeda.dart';

class MoedaHiveAdapter extends TypeAdapter<Moeda> {
  @override
  final typeId = 0;

  @override
  Moeda read(BinaryReader reader) {
    return Moeda(
      //      baseId: reader.readString(),
      icone: reader.readString(),
      nome: reader.readString(),
      sigla: reader.readString(),
      preco: reader.readDouble(),
      //      timestamp: reader.readDateTime(),
      //      preco: reader.readDouble(),
      //      preco: reader.readDouble(),
      //      preco: reader.readDouble(),
      //      preco: reader.readDouble(),
      //      preco: reader.readDouble(),
      //      preco: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, Moeda obj) {
    writer.writeString(obj.icone);
    writer.writeString(obj.nome);
    writer.writeString(obj.sigla);
    writer.writeDouble(obj.preco);
  }
}
