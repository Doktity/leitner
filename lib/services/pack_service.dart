import 'package:leitner/business/card_repository.dart';
import 'package:leitner/business/pack_repository.dart';
import 'package:leitner/business/user_repository.dart';

class PackService {
  final PackRepository _packRepository = PackRepository();
  final CardRepository _cardRepository = CardRepository();
  final UserRepository _userRepository = UserRepository();

  Future<List<Map<String, dynamic>>> getAllPacks() async {
    return await _packRepository.getAllPacks();
  }

  Future<bool> isUserSubscribed(String userId, String packId) async {
    List<String> packIds = await _userRepository.getDownloadedPackIds(userId);
    return packIds.contains(packId);
  }

  Future<Map<String, dynamic>?> getPack(String packId) async {
    return await _packRepository.getPack(packId);
  }

  Future<String> getPackName(String packId) async {
    Map<String, dynamic>? pack = await getPack(packId);
    return pack != null ? pack['name'] : '';
  }

  Future<void> addLienCard(String userId, String packId) async {
    Map<String, dynamic>? pack = await getPack(packId);
    if(pack != null) {
      List<String> cardIds = List<String>.from(pack['ids']);
      List<Map<String, dynamic>> cardList = await _cardRepository.getListCards(cardIds);

      await _packRepository.addLienCard(userId, cardList);
    }
  }

  Future<void> addPackId(String userId, String packId) async {
    List<String> packIds = await _userRepository.getDownloadedPackIds(userId);
    packIds.add(packId);
    await _userRepository.updateDownloadedPackIds(userId, packIds);
  }

  Future<void> removePackId(String userId, String packId) async {
    List<String> packIds = await _userRepository.getDownloadedPackIds(userId);
    packIds.remove(packId);
    await _userRepository.updateDownloadedPackIds(userId, packIds);
  }

  Future<void> removeLienCard(String userId, String packId) async {
    Map<String, dynamic>? pack = await getPack(packId);
    if(pack != null) {
      List<String> cardIds = List<String>.from(pack['ids']);
      await _packRepository.removeLienCard(userId, cardIds);
    }

  }
}