import 'package:leitner/business/card_repository.dart';
import 'package:leitner/business/pack_repository.dart';
import 'package:leitner/business/user_repository.dart';

class UserService {
  final UserRepository _userRepository = UserRepository();
  final CardRepository _cardRepository = CardRepository();
  final PackRepository _packRepository = PackRepository();

  Future<String> getUserName(String userId) async {
    return await _userRepository.getUserName(userId);
  }

  Future<bool> isAvailableCards(String userId) async {
    return await _userRepository.isAvailableCards(userId);
  }

  Future<void> updateAvailableCardCount(String userId) async {
    int count = await _cardRepository.getAvailableCardsCount(userId);
    await _userRepository.updateAvailableCardCount(userId, count);
  }

  Future<void> updateUsername(String userId, String username) async {
    await _userRepository.updateUsername(userId, username);
  }

  Future<List<String>> getDownloadedPackIds(String userId) async {
    return await _userRepository.getDownloadedPackIds(userId);
  }

  Future<List<String>> getPackIdsByType(String userId, String type) async {
    List<String> packIds = await _userRepository.getDownloadedPackIds(userId);
    List<String> filteredPackIds = [];

    for(String packId in packIds) {
      var packDetails = await _packRepository.getPack(packId);
      if(packDetails != null && (packDetails['type'] as String).toLowerCase() == type.toLowerCase()) {
        filteredPackIds.add(packId);
      }
    }
    return filteredPackIds;
  }
}