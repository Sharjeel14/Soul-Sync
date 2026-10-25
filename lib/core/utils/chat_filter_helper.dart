class ChatFilterHelper {
  const ChatFilterHelper._();

  // ── Email Detection ──
  static final RegExp _standardEmailRegExp = RegExp(
    r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
    caseSensitive: false,
  );

  static final RegExp _obfuscatedEmailRegExp = RegExp(
    r'\b[a-zA-Z0-9._%+-]+\s*(?:@|\[at\]|\(at\)|\bat\b)\s*[a-zA-Z0-9.-]+\s*(?:\.|\bdot\b|\[dot\]|\(dot\))\s*[a-zA-Z]{2,}\b',
    caseSensitive: false,
  );

  // ── Phone / Digit Sequences (7 or more digits with optional separators) ──
  static final RegExp _digitPhoneRegExp = RegExp(
    r'(?:(?:\+|00)\d{1,3}[\s\-\.]*)?(?:\(?\d{1,4}\)?[\s\-\.]*){6,}\d',
  );

  // Simple raw continuous or spaced digit sequence (7+ digits)
  static final RegExp _rawDigitSequenceRegExp = RegExp(
    r'(?:\d[\s\-\.\(\)\/]*){7,}',
  );

  // ── Digit Words Dictionary ──
  static const Set<String> _digitWords = {
    // 0
    'zero', 'sifr', 'صفر',
    // 1
    'one', 'wan', 'واحد',
    // 2
    'two', 'tow', 'اثنين', 'إثنين',
    // 3
    'three', 'tree', 'ثلاثة',
    // 4
    'four', 'fore', 'اربعة', 'أربعة',
    // 5
    'five', 'fiv', 'خمسة',
    // 6
    'six', 'ستة',
    // 7
    'seven', 'sevn', 'سبعة',
    // 8
    'eight', 'eigt', 'ثمانية',
    // 9
    'nine', 'nin', 'تسعة',
  };

  /// Returns true if the message contains phone numbers, spelled-out number
  /// sequences, or emails.
  static bool containsRestrictedContactInfo(String? text) {
    if (text == null || text.trim().isEmpty) return false;

    final trimmed = text.trim();

    // 1. Check for email
    if (_hasEmail(trimmed)) return true;

    // 2. Check for numeric phone numbers / sequences
    if (_hasPhoneOrDigitSequence(trimmed)) return true;

    // 3. Check for spelled-out number word sequences
    if (_hasSpelledOutNumberSequence(trimmed)) return true;

    return false;
  }

  static bool _hasEmail(String text) {
    if (_standardEmailRegExp.hasMatch(text)) return true;
    if (_obfuscatedEmailRegExp.hasMatch(text)) return true;
    return false;
  }

  static bool _hasPhoneOrDigitSequence(String text) {
    if (_digitPhoneRegExp.hasMatch(text)) return true;
    if (_rawDigitSequenceRegExp.hasMatch(text)) return true;

    // Secondary check: strip everything except digits
    // If consecutive digits inside any token/phrase exceed 6, flag it.
    final words = text.split(RegExp(r'\s+'));
    for (final word in words) {
      final digitsOnly = word.replaceAll(RegExp(r'\D'), '');
      if (digitsOnly.length >= 7) return true;
    }

    return false;
  }

  static bool _hasSpelledOutNumberSequence(String text) {
    // Normalize string: lowercase, replace punctuation with space
    final normalized = text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s\u0600-\u06FF]'), ' ');

    final tokens = normalized.split(RegExp(r'\s+')).where((t) => t.isNotEmpty);

    int consecutiveNumberCount = 0;

    for (final token in tokens) {
      final isDigitWord = _digitWords.contains(token);
      final isSingleDigit = RegExp(r'^\d$').hasMatch(token);

      if (isDigitWord || isSingleDigit) {
        consecutiveNumberCount++;
        // 4 or more spelled-out / single digits in sequence (e.g. "one tow three four five")
        if (consecutiveNumberCount >= 4) {
          return true;
        }
      } else {
        consecutiveNumberCount = 0;
      }
    }

    return false;
  }
}
