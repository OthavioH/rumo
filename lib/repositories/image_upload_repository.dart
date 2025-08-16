import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ImageUploadRepository {
  late final SupabaseClient supabase;

  ImageUploadRepository() {
    supabase = Supabase.instance.client;
  }

  Future<String> uploadImage(File image) async {
    final fileType = image.path.split('.').last;
    final imageId = Uuid().v4();
    final filename = '$imageId.$fileType';
    
    await supabase.storage.from('images').upload(filename, image);
    return supabase.storage.from('images').getPublicUrl(filename);
  }
}
