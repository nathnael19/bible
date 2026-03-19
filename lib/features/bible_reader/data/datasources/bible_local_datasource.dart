import '../models/bible_version_model.dart';
import '../models/verse_model.dart';

/// Mock local data source — simulates a local database / bundled JSON.
class BibleLocalDataSource {
  List<BibleVersionModel> getBibleVersions() {
    return const [
      BibleVersionModel(
        id: 'amh_standard',
        name: 'Amharic Standard',
        language: 'አማርኛ',
        abbreviation: 'ASB',
      ),
      BibleVersionModel(
        id: 'kjv',
        name: 'King James Version',
        language: 'English',
        abbreviation: 'KJV',
      ),
      BibleVersionModel(
        id: 'esv',
        name: 'English Standard Version',
        language: 'English',
        abbreviation: 'ESV',
      ),
      BibleVersionModel(
        id: 'tig',
        name: 'Tigrinya Bible',
        language: 'ትግርኛ',
        abbreviation: 'TIG',
      ),
      BibleVersionModel(
        id: 'oromo',
        name: 'Oromo Bible (Macaafa Qulqulluu)',
        language: 'Oromiffa',
        abbreviation: 'ORO',
      ),
    ];
  }

  List<VerseModel> getVerses({
    required String versionId,
    required String book,
    required int chapter,
  }) {
    // Return Amharic or English Genesis 1 based on versionId
    if (versionId == 'amh_standard' || versionId == 'oromo') {
      return _amharicGenesis1;
    }
    return _englishGenesis1;
  }

  static const List<VerseModel> _amharicGenesis1 = [
    VerseModel(number: 1, bookName: 'ዘፍጥረት', chapter: 1,
        text: 'እግዚአብሔር ሰማይና ምድርን ፈጠረ።'),
    VerseModel(number: 2, bookName: 'ዘፍጥረት', chapter: 1,
        text: 'ምድርም ባድማና ጽልመት ነበረ፤ ጥልቅም ጨለማ ነበረበት። የእግዚአብሔርም መንፈስ በውኃ ላይ ይሰፍ ነበር።'),
    VerseModel(number: 3, bookName: 'ዘፍጥረት', chapter: 1,
        text: 'እግዚአብሔርም፡ ብርሃን ይሁን አለ፤ ብርሃንም ሆነ።'),
    VerseModel(number: 4, bookName: 'ዘፍጥረት', chapter: 1,
        text: 'እግዚአብሔርም ብርሃኑ መልካም እንደ ሆነ አየ፤ እግዚአብሔርም ብርሃኑን ከጨለማ ለየ።'),
    VerseModel(number: 5, bookName: 'ዘፍጥረት', chapter: 1,
        text: 'እግዚአብሔርም ብርሃኑን ቀን ጨለማውንም ሌሊት ብሎ ጠራ። ምሽትና ንጋት ሆነ፤ ይህ የመጀመሪያው ቀን ነው።'),
    VerseModel(number: 6, bookName: 'ዘፍጥረት', chapter: 1,
        text: 'እግዚአብሔርም፡ ውኃ ከውኃ ይለዩ ዘንድ መካከሉ ጠፈር ይሁን አለ።'),
    VerseModel(number: 7, bookName: 'ዘፍጥረት', chapter: 1,
        text: 'እግዚአብሔርም ጠፈሩን አደረገ፤ ከጠፈሩ በታች ያለውን ውኃ ከጠፈሩ በላይ ካለው ውኃ ለየ። ሆነም።'),
    VerseModel(number: 8, bookName: 'ዘፍጥረት', chapter: 1,
        text: 'እግዚአብሔርም ጠፈሩን ሰማይ ብሎ ጠራ። ምሽትና ንጋት ሆነ፤ ይህ ሁለተኛ ቀን ነው።'),
    VerseModel(number: 9, bookName: 'ዘፍጥረት', chapter: 1,
        text: 'እግዚአብሔርም፡ ከሰማይ በታች ያለው ውኃ ወደ አንድ ቦታ ይሰብሰብ፤ ደርቅም ይታይ አለ። ሆነም።'),
    VerseModel(number: 10, bookName: 'ዘፍጥረት', chapter: 1,
        text: 'እግዚአብሔርም ደርቁን ምድር ብሎ ጠራ፤ የውኃውንም ስብስብ ባሕር ብሎ ጠራ። እግዚአብሔርም መልካም እንደ ሆነ አየ።'),
    VerseModel(number: 11, bookName: 'ዘፍጥረት', chapter: 1,
        text: 'እግዚአብሔርም፡ ምድር ቅጠልን፥ ዘር የሚዘሩትን ዕፅዋት፥ ዘራቸው ባሕሪቸው ሆኖ ፍሬ የሚያፈሩ ፍሬ ዛፎችን ታብቅል አለ። ሆነም።'),
    VerseModel(number: 12, bookName: 'ዘፍጥረት', chapter: 1,
        text: 'ምድርም ቅጠልን፥ ዘር የሚዘሩትን ዕፅዋት ባሕሪቸው ሆኖ፥ ዘራቸው ባሕሪቸው ሆኖ ፍሬ የሚያፈሩ ፍሬ ዛፎችን አበቀለች። እግዚአብሔርም መልካም እንደ ሆነ አየ።'),
    VerseModel(number: 13, bookName: 'ዘፍጥረት', chapter: 1,
        text: 'ምሽትና ንጋት ሆነ፤ ይህ ሦስተኛ ቀን ነው።'),
    VerseModel(number: 14, bookName: 'ዘፍጥረት', chapter: 1,
        text: 'እግዚአብሔርም፡ ቀንን ከሌሊት ይለዩ ዘንድ ምልክትም ለዋቢ ዕለትም ዓመትም ይሆኑ ዘንድ ፀሐቆችም ሰማያዊ ጠፈር ላይ ይሁኑ አለ።'),
    VerseModel(number: 15, bookName: 'ዘፍጥረት', chapter: 1,
        text: 'ምድርንም ያበሩ ዘንድ ሰማያዊ ጠፈር ፀሐቆች ይሁኑ አለ። ሆነም።'),
  ];

  static const List<VerseModel> _englishGenesis1 = [
    VerseModel(number: 1, bookName: 'Genesis', chapter: 1,
        text: 'In the beginning, God created the heavens and the earth.'),
    VerseModel(number: 2, bookName: 'Genesis', chapter: 1,
        text: 'The earth was without form and void, and darkness was over the face of the deep. And the Spirit of God was hovering over the face of the waters.'),
    VerseModel(number: 3, bookName: 'Genesis', chapter: 1,
        text: 'And God said, "Let there be light," and there was light.'),
    VerseModel(number: 4, bookName: 'Genesis', chapter: 1,
        text: 'And God saw that the light was good. And God separated the light from the darkness.'),
    VerseModel(number: 5, bookName: 'Genesis', chapter: 1,
        text: 'God called the light Day, and the darkness he called Night. And there was evening and there was morning, the first day.'),
    VerseModel(number: 6, bookName: 'Genesis', chapter: 1,
        text: 'And God said, "Let there be an expanse in the midst of the waters, and let it separate the waters from the waters."'),
    VerseModel(number: 7, bookName: 'Genesis', chapter: 1,
        text: 'And God made the expanse and separated the waters that were under the expanse from the waters that were above the expanse. And it was so.'),
    VerseModel(number: 8, bookName: 'Genesis', chapter: 1,
        text: 'And God called the expanse Heaven. And there was evening and there was morning, the second day.'),
    VerseModel(number: 9, bookName: 'Genesis', chapter: 1,
        text: 'And God said, "Let the waters under the heavens be gathered together into one place, and let the dry land appear." And it was so.'),
    VerseModel(number: 10, bookName: 'Genesis', chapter: 1,
        text: 'God called the dry land Earth, and the waters that were gathered together he called Seas. And God saw that it was good.'),
    VerseModel(number: 11, bookName: 'Genesis', chapter: 1,
        text: 'And God said, "Let the earth sprout vegetation, plants yielding seed, and fruit trees bearing fruit in which is their seed, each according to its kind, on the earth." And it was so.'),
    VerseModel(number: 12, bookName: 'Genesis', chapter: 1,
        text: 'The earth brought forth vegetation, plants yielding seed according to their own kinds, and trees bearing fruit in which is their seed, each according to its kind. And God saw that it was good.'),
    VerseModel(number: 13, bookName: 'Genesis', chapter: 1,
        text: 'And there was evening and there was morning, the third day.'),
    VerseModel(number: 14, bookName: 'Genesis', chapter: 1,
        text: 'And God said, "Let there be lights in the expanse of the heavens to separate the day from the night. And let them be for signs and for seasons, and for days and years."'),
    VerseModel(number: 15, bookName: 'Genesis', chapter: 1,
        text: 'And let them be lights in the expanse of the heavens to give light upon the earth." And it was so.'),
  ];
}
