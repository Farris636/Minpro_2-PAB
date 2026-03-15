import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getArmada() async {
    final data = await supabase.from('armada').select().order('id');

    return data;
  }

  Future<void> addArmada(String name, String plate, String status) async {
    await supabase.from('armada').insert({
      'name': name,
      'plate': plate,
      'status': status,
    });
  }

  Future<void> updateArmada(
    int id,
    String name,
    String plate,
    String status,
  ) async {
    await supabase
        .from('armada')
        .update({'name': name, 'plate': plate, 'status': status})
        .eq('id', id);
  }

  Future<void> deleteArmada(int id) async {
    await supabase.from('armada').delete().eq('id', id);
  }
}
