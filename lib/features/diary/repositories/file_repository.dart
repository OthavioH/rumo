import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class FileRepository {
  final dio = Dio();

  Future<File?> downloadImage(String imageUrl) async {
    try {

      final fileName = imageUrl.split('/').last;

      final directory = await getApplicationDocumentsDirectory();

      File file = File('${directory.path}/$fileName');

      if(await file.exists()) {
        return file;
      }

      final response = await dio.get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode != 200){
        throw Exception(
          "Failed to download image. StatusCode: ${response.statusCode}",
        );
      }

      file = await file.writeAsBytes(response.data);
      return file;
    } catch (error, stackTrace) {
      log("Error downloading image", error: error, stackTrace: stackTrace);
      return null;
    }
  }
}
