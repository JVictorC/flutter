import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'package:file_picker/file_picker.dart';

class LibraryDocumentUtil extends FileProvider {
  @override
  Future<FileEntity?> getFile({List<String>? allowedExtensions}) async {
    allowedExtensions ??= ['pdf', 'jpeg', 'png', 'jpg'];
    String invalidDocumentText =
        'Não foi possível fazer o upload do seu exame, pois o arquivo selecionado não está nos formatos aceitos.\nFormatos aceitos: pdf, jpeg e png.';
    String invalidDocumentSize =
        'Não foi possível fazer o upload do seu exame, pois o arquivo selecionado ultrapassa o limite de 20 MB.';
    const int limitMbSize = 20;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    if (result == null) return null;
    String? fileName = result.files.single.name;
    String fileExtension =
        FileProvider.getFileExtension(result.files.first.name);

    if (kIsWeb) {
      File file = File(result.files.first.name);

      if (!allowedExtensions.contains(fileExtension.toLowerCase())) {
        throw FileExtensionException(error: invalidDocumentText);
      }
      if (!hasLimitSize(result.files.single.size, limitMbSize: limitMbSize)) {
        throw FileSizeException(error: invalidDocumentSize);
      }
      return FileEntity(
        file,
        result.files.single.bytes,
        fileName: fileName,
      );
    }
    File file = File(result.files.single.path!);

    if (!allowedExtensions.contains(fileExtension)) {
      throw FileExtensionException(error: invalidDocumentText);
    }

    if (!hasLimitSize(file.lengthSync(), limitMbSize: limitMbSize)) {
      throw FileSizeException(error: invalidDocumentSize);
    }

    return FileEntity(
      file,
      await file.readAsBytes(),
      fileName: fileName,
    );
  }
}

abstract class FileProvider {
  Future<FileEntity?> getFile({List<String> allowedExtensions});

  String getFileName(String path) {
    String fileName = (path.split('/').last);

    if (fileName.length > 25) fileName = getResumedName(fileName);

    return fileName;
  }

  bool hasLimitSize(int sizeInBytes, {required int limitMbSize}) {
    double sizeInMb = sizeInBytes / (1024 * 1024);
    if (sizeInMb > limitMbSize) {
      return false;
    }
    return true;
  }

  String getResumedName(String fileName) {
    final String extensionFile = getFileExtension(fileName);

    String resumedName = fileName.substring(0, 25) + '...' + extensionFile;

    return resumedName;
  }

  static getFileExtension(String path) {
    String fileExtension = path.split('.').last;

    return fileExtension;
  }
}

class FileEntity {
  final File? file;
  final Uint8List? bytes;
  final String? fileName;
  final bool showMyExamsStep;

  FileEntity(
    this.file,
    this.bytes, {
    this.fileName,
    this.showMyExamsStep = true,
  });

  FileEntity copyWith({
    File? file,
    Uint8List? bytes,
    String? fileName,
    bool? showMyExamsStep,
  }) =>
      FileEntity(
        file ?? this.file,
        bytes ?? this.bytes,
        fileName: fileName ?? this.fileName,
        showMyExamsStep: showMyExamsStep ?? this.showMyExamsStep,
      );
}

class FileSizeException implements Exception {
  final String error;

  FileSizeException({required this.error});
}

class FileExtensionException implements Exception {
  final String error;

  FileExtensionException({required this.error});
}
