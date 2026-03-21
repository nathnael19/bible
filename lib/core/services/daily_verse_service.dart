/// A curated list of well-known Bible verses with Amharic text and reference.
/// The daily verse is picked deterministically based on the day of the year,
/// so every user sees the same verse on the same day but it rotates daily.
class DailyVerseService {
  DailyVerseService._();

  static const List<_Verse> _verses = [
    _Verse(
      text: '«እግዚአብሔር ብርሃኔና መድኃኒቴ ነው፤ የሚያስፈራኝ ማን ነው?»',
      reference: 'መዝሙረ ዳዊት ፳፯:፩',
      referenceEn: 'Psalm 27:1',
    ),
    _Verse(
      text: '«ለሁሉ ጊዜ አለው፥ ከሰማይ በታች ላለ ነገር ሁሉ 时 አለው።»',
      reference: 'መክብብ ፫:፩',
      referenceEn: 'Ecclesiastes 3:1',
    ),
    _Verse(
      text: '«ጌታዬ አምላኬ ሆይ፥ በአንተ ታምኛለሁ።»',
      reference: 'መዝሙረ ዳዊት ፯:፩',
      referenceEn: 'Psalm 7:1',
    ),
    _Verse(
      text: '«እግዚአብሔር ጌታ ኃይሌ ነው፤ እርሱ እግሬን እንደ አጋዘን ያደርጋቸዋል።»',
      reference: 'ዕንባቆም ፫:፲፱',
      referenceEn: 'Habakkuk 3:19',
    ),
    _Verse(
      text: '«ናዳህ ወደ እኔ ና፤ ሁሉም ደካሞችና ሸክማቸው የከበዳቸው፤ እኔ አሳርፋችኋለሁ።»',
      reference: 'ማቴዎስ ፲፩:፳፰',
      referenceEn: 'Matthew 11:28',
    ),
    _Verse(
      text: '«እግዚአብሔር እረኛዬ ነው፤ የሚጐድለኝ አይኖርም።»',
      reference: 'መዝሙረ ዳዊት ፳፫:፩',
      referenceEn: 'Psalm 23:1',
    ),
    _Verse(
      text: '«ፍቅር ይቅር ይላል፥ ፍቅር ደጉን ያደርጋል፥ አይቀናም፥ አይታበይም።»',
      reference: '፩ ቆሮንቶስ ፲፫:፬',
      referenceEn: '1 Corinthians 13:4',
    ),
    _Verse(
      text: '«ሁሉን ነገር ማድረግ እችላለሁ፤ ኃይል ከሚሰጠኝ ከክርስቶስ ጋር።»',
      reference: 'ፊልጵስዩስ ፬:፲፫',
      referenceEn: 'Philippians 4:13',
    ),
    _Verse(
      text: '«ስለዚህ ጌታ ራሱ ምልክት ይሰጣቸዋል፤ እነሆ፥ ድንግል ትፀንሳለች ወንድ ልጅ ትወልዳለች ስሙንም ዓማኑኤል ትለዋለች።»',
      reference: 'ኢሳይያስ ፯:፲፬',
      referenceEn: 'Isaiah 7:14',
    ),
    _Verse(
      text: '«ጽድቅህን እንደ ብርሃን አድርጎ ያወጣዋል፤ ፍርድህንም እንደ ቀትር ፀሐይ።»',
      reference: 'መዝሙረ ዳዊት ፴፯:፮',
      referenceEn: 'Psalm 37:6',
    ),
    _Verse(
      text: '«የሚተማመኑ ሁሉ ስለ አጸደቀ ለሁሉ ጽድቅ ይሆን ዘንድ።»',
      reference: 'ሮሜ ፩:፲፯',
      referenceEn: 'Romans 1:17',
    ),
    _Verse(
      text: '«ዓለምን እግዚአብሔር እንዲሁ ወደደ፤ ነቶ ሰው ሁሉ እንዳይጠፋ ሕይወቱ ይሆነው ዘንድ።»',
      reference: 'ዮሐንስ ፫:፲፮',
      referenceEn: 'John 3:16',
    ),
    _Verse(
      text: '«ጌታ ቅርብ ነው። ስለ ምንም አትጨነቁ፤ ነገር ግን ያለ ጥያቄ ባለ ምስጋናና ጸሎት ፍላጎታችሁን ለእግዚአብሔር ንገሩ።»',
      reference: 'ፊልጵስዩስ ፬:፭-፮',
      referenceEn: 'Philippians 4:5-6',
    ),
    _Verse(
      text: '«ወደ እኔ ና፤ ያለ ወጪ ውኃው ካለው ሁሉ ይጠጣ።»',
      reference: 'ራዕይ ፳፪:፲፯',
      referenceEn: 'Revelation 22:17',
    ),
    _Verse(
      text: '«ዓይናቸውን ሙሉ በሙሉ ጠርጎ ያስጠርጋቸዋል፤ ሞት ወደ ፊት አይኖርም።»',
      reference: 'ራዕይ ፳፩:፬',
      referenceEn: 'Revelation 21:4',
    ),
    _Verse(
      text: '«ጌታ ሰጠ ጌታ ወሰደ፤ የጌታ ስም ይባረክ።»',
      reference: 'ኢዮብ ፩:፳፩',
      referenceEn: 'Job 1:21',
    ),
    _Verse(
      text: '«ቤቴ የጸሎት ቤት ትባላለች ተብሏልና።»',
      reference: 'ማቴዎስ ፳፩:፲፫',
      referenceEn: 'Matthew 21:13',
    ),
    _Verse(
      text: '«ወይ ሞት ወይ ሕይወት ወይ መላዕክቶ ለሁሉ ከፍቅሩ ሊለዩን አይችሉም።»',
      reference: 'ሮሜ ፰:፴፰',
      referenceEn: 'Romans 8:38',
    ),
    _Verse(
      text: '«አምኑ ብቻ፤ ያን ጊዜ ትድናለህ ቤትህም ይድናል።»',
      reference: 'የሐ.ሥ ፲፮:፴፩',
      referenceEn: 'Acts 16:31',
    ),
    _Verse(
      text: '«ጌታ መልካም ነው፤ ለጸናው ምሽግ ነው፤ ወደ እርሱ ለሚሸሸጉ ጠባቂ ነው።»',
      reference: 'ናሆም ፩:፯',
      referenceEn: 'Nahum 1:7',
    ),
    _Verse(
      text: '«ተቸገሩና ሞቅ አላቸው፤ ያን ጊዜ ጩኸዋቸው ወደ ጌታ፤ ከሁሉም ፈተናዎቻቸው እርሱ አዳናቸው።»',
      reference: 'መዝሙረ ዳዊት ፻፯:፳፰',
      referenceEn: 'Psalm 107:28',
    ),
  ];

  /// Returns today's verse, deterministically chosen from the curated list.
  /// Every user sees the same verse on the same calendar day.
  static _Verse getToday() {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return _verses[dayOfYear % _verses.length];
  }
}

class _Verse {
  final String text;
  final String reference;
  final String referenceEn;

  const _Verse({
    required this.text,
    required this.reference,
    required this.referenceEn,
  });
}
