import 'package:file_picker/file_picker.dart';

Future<String?> pickPDFFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null) {
    PlatformFile file = result.files.first;
    String? path = file.path;
    return path;
  }

  return null;
}
