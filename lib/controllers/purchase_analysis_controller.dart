import 'dart:developer';
import 'dart:io';
import 'package:meu_financeiro/repositories/transaction_repository.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart' as xml;

class PurchaseAnalysisController {
  PurchaseAnalysisController({
    required this.transactionRepository,
  });

  final TransactionRepository transactionRepository;

  Future<int?> lerArquivoOFX(
      String? selectedFilePath, double purchaseValue) async {
    Directory diretorio = await getApplicationDocumentsDirectory();

    File ofxFile = File(join(diretorio.path, selectedFilePath));

    if (await ofxFile.exists()) {
      String ofxContent = await ofxFile.readAsString();

      xml.XmlDocument documento = xml.XmlDocument.parse(ofxContent);

      var elementosBALAMT = documento.findAllElements('BALAMT');

      if (elementosBALAMT.isNotEmpty) {
        var balance = elementosBALAMT.first.text;
        var balanceFloat = double.parse(balance);

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
      log('O arquivo OFX não foi encontrado.');
      var balance = await transactionRepository.getBalances();
      var balanceFloat = double.parse(balance.data!.totalBalance.toString());

      double valorParcela = balanceFloat * 0.3;
      int numParcelas = (purchaseValue ~/ valorParcela);

      if (purchaseValue % valorParcela != 0) {
        numParcelas += 1;
      }

      return numParcelas;
    }
    return null;
  }
}
