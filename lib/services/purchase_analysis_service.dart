import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart' as xml;

Future<int?> lerArquivoOFX(
    String? selectedFilePath, double purchaseValue) async {
  // Obtenha o diretório de armazenamento local do aplicativo
  Directory diretorio = await getApplicationDocumentsDirectory();

  // Crie um objeto File com o caminho do arquivo OFX
  File ofxFile = File(join(diretorio.path, selectedFilePath));

  // Verifique se o arquivo existe
  if (await ofxFile.exists()) {
    // Leia o conteúdo do arquivo
    String ofxContent = await ofxFile.readAsString();

    // Analise o conteúdo do OFX como um documento XML
    xml.XmlDocument documento = xml.XmlDocument.parse(ofxContent);

    // Acesse o elemento BALAMT
    var elementosBALAMT = documento.findAllElements('BALAMT');

    // Extraia o valor do campo BALAMT
    if (elementosBALAMT.isNotEmpty) {
      var balance = elementosBALAMT.first.text;
      var balanceFloat = double.parse(balance);
      double? valorGuardar;

      if (purchaseValue > balanceFloat) {
        valorGuardar = (balanceFloat - purchaseValue).abs();
      }

      double valorParcela = balanceFloat * 0.3;
      int numParcelas = (purchaseValue ~/ valorParcela);

      if (purchaseValue % valorParcela != 0) {
        numParcelas += 1;
      }

      return numParcelas;
    } else {
      log('Campo BALAMT não encontrado.');
    }
  } else {
    print('O arquivo OFX não foi encontrado.');
  }
}
