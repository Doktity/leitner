import 'package:leitner/business/card_repository.dart';
import 'package:leitner/business/pack_repository.dart';

class PackService {
  final PackRepository _packRepository = PackRepository();
  final CardRepository _cardRepository = CardRepository();

  Future<List<Map<String, dynamic>>> getAllPacks() async {
    return await _packRepository.getAllPacks();
  }

  Future<bool> isUserSubscribed(String userId, String packId) async {
    return await _packRepository.isUserSubscribed(userId, packId);
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
      List<String> cardIds = List<String>.from(pack['cards']);
      List<Map<String, dynamic>> cardList = await _cardRepository.getListCards(cardIds);

      await _packRepository.addLienCard(userId, packId, cardList);
    }
  }

  Future<void> removeLienCard(String userId, String packId) async {
    await _packRepository.removeLienCard(userId, packId);
  }
}