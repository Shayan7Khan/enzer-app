import 'dart:io';
import 'package:file_picker/file_picker.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;

class FilePickerService {
  File? selectedImage;
  final _imagePicker = ImagePicker();
  final Logger log = Logger();

  Future<File?> pickImage() async {
    return await pickImageWithoutCompression();
  }

  Future<File?> pickImageWithCompression() async {
    File? selectedImage;
    final image50 = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );
    final image100 = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    if (image50 != null) selectedImage = File(image50.path);
    log.d('Image50 Size: ${await image50?.length()}');
    log.d('Image100 Size: ${await image100?.length()}');
    return selectedImage;
  }

  Future<File?> pickImageWithoutCompression() async {
    File? selectedImage;
    final filePicker = FilePicker.platform;
    FilePickerResult? result = await filePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      selectedImage = File(result.paths.first!);
      final extension = p.extension(selectedImage.path).toLowerCase();
      log.d('@FilePickerService.pickImage ==> Extension: $extension');

      // convert to JPEG so Android can display HEIC and all other formats
      final converted = await _convertToJpeg(selectedImage);
      if (converted != null) selectedImage = converted;
    }

    return selectedImage;
  }

  Future<File?> _convertToJpeg(File file) async {
    try {
      final targetPath =
          '${file.parent.path}/${DateTime.now().millisecondsSinceEpoch}_avatar.jpg';
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        format: CompressFormat.jpeg,
        quality: 90,
      );
      if (result == null) return null;
      log.d('@FilePickerService converted to JPEG: $targetPath');
      return File(result.path);
    } catch (e) {
      log.d('@FilePickerService _convertToJpeg error: $e');
      return null;
    }
  }
}
