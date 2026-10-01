import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Asks once for a Play Store rating, at a good moment (after a passed mock exam).
/// Google decides itself whether the dialog is actually shown (quota).
class ReviewPrompt {
  static const _key = 'review_prompt_shown';
  static bool _requested = false;

  static Future<void> maybeAsk() async {
    if (_requested) return;
    _requested = true;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_key) ?? false) return;
    final review = InAppReview.instance;
    if (await review.isAvailable()) {
      await prefs.setBool(_key, true);
      await review.requestReview();
    }
  }
}
