library murmurhash;

// Triple shift is currently being implemented in dart:
// https://github.com/dart-lang/language/issues/478
// until then:
extension TripleShift on int {
  int tripleShift(int count) {
    return (this >> count) & ~(-1 << (64 - count));
  }
}

class MurmurHash {
  /// MurmurHash v3
  ///
  /// Ported from: https://github.com/garycourt/murmurhash-js
  static int v3(String key, int seed) {
    int remainder = key.length & 3;
    int bytes = key.length - remainder;
    int h1 = seed;
    int c1 = 0xcc9e2d51;
    int c2 = 0x1b873593;
    int i = 0;
    int k1, h1b;
    while (i < bytes) {
      k1 = ((key.codeUnitAt(i) & 0xff)) |
          ((key.codeUnitAt(++i) & 0xff) << 8) |
          ((key.codeUnitAt(++i) & 0xff) << 16) |
          ((key.codeUnitAt(++i) & 0xff) << 24);
      ++i;
      k1 = ((((k1 & 0xffff) * c1) +
              ((((k1.tripleShift(16)) * c1) & 0xffff) << 16))) &
          0xffffffff;
      k1 = (k1 << 15) | (k1.tripleShift(17));
      k1 = ((((k1 & 0xffff) * c2) +
              ((((k1.tripleShift(16)) * c2) & 0xffff) << 16))) &
          0xffffffff;

      h1 ^= k1;
      h1 = (h1 << 13) | (h1.tripleShift(19));
      h1b = ((((h1 & 0xffff) * 5) +
              ((((h1.tripleShift(16)) * 5) & 0xffff) << 16))) &
          0xffffffff;
      h1 = (((h1b & 0xffff) + 0x6b64) +
          ((((h1b.tripleShift(16)) + 0xe654) & 0xffff) << 16));
    }
    k1 = 0;

    switch (remainder) {
      case 3:
        k1 ^= (key.codeUnitAt(i + 2) & 0xff) << 16;
        continue case2;
      case2:
      case 2:
        k1 ^= (key.codeUnitAt(i + 1) & 0xff) << 8;
        continue case1;
      case1:
      case 1:
        k1 ^= (key.codeUnitAt(i) & 0xff);

        k1 = (((k1 & 0xffff) * c1) +
                ((((k1.tripleShift(16)) * c1) & 0xffff) << 16)) &
            0xffffffff;
        k1 = (k1 << 15) | (k1.tripleShift(17));
        k1 = (((k1 & 0xffff) * c2) +
                ((((k1.tripleShift(16)) * c2) & 0xffff) << 16)) &
            0xffffffff;
        h1 ^= k1;
    }
    h1 ^= key.length;

    h1 ^= h1.tripleShift(16);
    h1 = (((h1 & 0xffff) * 0x85ebca6b) +
            ((((h1.tripleShift(16)) * 0x85ebca6b) & 0xffff) << 16)) &
        0xffffffff;
    h1 ^= h1.tripleShift(13);
    h1 = ((((h1 & 0xffff) * 0xc2b2ae35) +
            ((((h1.tripleShift(16)) * 0xc2b2ae35) & 0xffff) << 16))) &
        0xffffffff;
    h1 ^= h1.tripleShift(16);

    return h1.tripleShift(0);
  }
}
