import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'handler_files_picker.dart';

class CameraUtil {
  Future<FileEntity> getFile() async {
    File _image;

    final picker = ImagePicker();

    XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    _image = File(pickedFile?.path ?? '');
    final String? fileName = _image.path.split('/').last;
    return FileEntity(
      _image,
      await pickedFile?.readAsBytes(),
      fileName: fileName,
    );
  }
}
