import 'package:leitner/business/card_repository.dart';
import 'package:leitner/business/user_repository.dart';

class UserService {
  final UserRepository _userRepository = UserRepository();
  final CardRepository _cardRepository = CardRepository();

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
}