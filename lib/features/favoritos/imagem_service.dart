import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagemService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> tirarFoto() async {
    final XFile? foto = await _picker.pickImage(source: ImageSource.camera);
    if (foto == null) return null;
    return File(foto.path);
  }

  Future<File?> pegarDaGaleria() async {
    final XFile? foto = await _picker.pickImage(source: ImageSource.gallery);
    if (foto == null) return null;
    return File(foto.path);
  }
}
