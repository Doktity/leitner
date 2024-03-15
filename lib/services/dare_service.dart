import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leitner/business/dare_repository.dart';
import 'package:leitner/business/pack_repository.dart';

class DareService {
  final DareRepository _dareRepository = DareRepository();
  final PackRepository _packRepository = PackRepository();

  Future<List<Map<String, dynamic>>> getAllDares() async {
    return _dareRepository.getAllDares();
  }

  Future<List<Map<String, dynamic>>> getUserDares(String userId) async {
    List<Map<String, dynamic>> dareLinks = await _dareRepository.getLiensUserDare(userId);
    List<Map<String, dynamic>> userDares = [];

    for(var link in dareLinks) {
      String? dareId = link['dareId'];
      if(dareId != null) {
        var dareData = await _dareRepository.getDareById(dareId);
        if(dareData != null) {
          dareData['id'] = link['dareId'];
          userDares.add(dareData);
        }
      }
    }

    return userDares;
  }

  Future<Map<String, dynamic>> getRandomDare(String userId) async {
    List<Map<String, dynamic>> liensUserCard = await _dareRepository.getLiensUserDare(userId);

    List<String> dareIds = liensUserCard.map((doc) => doc['dareId']).where((id) => id != null).cast<String>().toList();

    List<Map<String, dynamic>> dares = [];
    for (String dareId in dareIds) {
      Map<String, dynamic>? dare = await _dareRepository.getDareById(dareId);
      if (dare != null) {
        dares.add(dare);
      }
    }

    if (dares.isEmpty) {
      throw Exception('No dares found for the given card IDs.');
    }

    Map<String, dynamic> randomDare = dares[Random().nextInt(dares.length)];
    return randomDare;
  }

  Future<List<String>> getCategories() async {
    List<Map<String, dynamic>> dares = await _dareRepository.getAllDares();

    // Set of categories to avoid duplicates
    var categories = <String>{};

    // Add categories into set
    for(var dare in dares) {
      if(dare.containsKey('categories') && dare['categories'] is List) {
        List<dynamic> cardCategories = dare['categories'];
        categories.addAll(cardCategories.cast<String>());
      }
    }

    // Change set into list
    return categories.toList();
  }

  Future<void> deleteDare(String dareId) async {
    try {
      // Start a batch write
      WriteBatch batch = FirebaseFirestore.instance.batch();

      await _dareRepository.deleteDare(dareId, batch);

      //Find pack with that card and delete it from the list
      _packRepository.removeIdFromIds(dareId, batch);

      // Commit batch
      await batch.commit();
    } catch(e) {
      print('Error deleting card: $e');
    }
  }

  Future<void> addDare(String userId, Map<String, dynamic> dare) async {
    await _dareRepository.addDare(userId, dare);
  }

  Future<void> updateDare(String dareId, Map<String, dynamic> dare) async {
    await _dareRepository.updateDare(dareId, dare);
  }

  Future<List<Map<String, dynamic>>> getListDares(List<String> ids) async {
    return await _dareRepository.getListDares(ids);
}
}