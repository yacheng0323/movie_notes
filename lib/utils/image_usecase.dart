import 'dart:convert';
import 'dart:io';

class ImageUsecase {
  //* 圖片 轉成 base64
  String imageToBase64(File imageFile) {
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  //* base64 轉成 圖片
  File base64ToImage(String base64String) {
    List<int> imageBytes = base64Decode(base64String);
    String tempPath = '${Directory.systemTemp.path}/temp_image.png';
    File tempFile = File(tempPath);
    tempFile.writeAsBytesSync(imageBytes);
    return tempFile;
  }
}
