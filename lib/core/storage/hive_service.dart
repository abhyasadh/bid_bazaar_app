import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../../config/constants/hive_table_constant.dart';

final hiveServiceProvider = Provider<HiveService>((ref) => HiveService());

class HiveService {
  Future<void> init() async {
    var directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
  }

  Future<void> setAccessToken({required String accessToken}) async {
    final box = await Hive.openBox(HiveTableConstant.userBox);
    await box.put('token', accessToken);
    await box.close();
  }

  Future<void> removeAccessToken() async {
    final box = await Hive.openBox(HiveTableConstant.userBox);
    await box.delete('token');
    await box.close();
  }

  Future<String?> getAccessToken() async {
    try {
      final box = await Hive.openBox(HiveTableConstant.userBox);
      final data = box.get('token');
      if (data == null) {
        return null;
      }
      return data.toString();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> setPhone({required String phone}) async {
    final box = await Hive.openBox(HiveTableConstant.userBox);
    await box.put('phone', phone);
    await box.close();
  }

  Future<void> removePhone() async {
    final box = await Hive.openBox(HiveTableConstant.userBox);
    await box.delete('phone');
    await box.close();
  }

  Future<String?> getPhone() async {
    try {
      final box = await Hive.openBox(HiveTableConstant.userBox);
      final data = box.get('phone');
      if (data == null) {
        return null;
      }
      return data.toString();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // ============================= Close Hive ===========================
  Future<void> closeHive() async {
    await Hive.close();
  }

  // ============================= Delete Hive ===========================
  Future<void> deleteHive() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
    await Hive.deleteFromDisk();
  }
}
