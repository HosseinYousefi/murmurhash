import 'package:murmurhash/murmurhash.dart';
import 'package:test/test.dart';

void main() {
  test('hello, seed 0', () {
    expect(MurmurHash.v3('hello', 0), 613153351);
  });
  test('world, seed 1', () {
    expect(MurmurHash.v3('world', 1), 1648897759);
  });
  test('Some Larger String!, seed 123', () {
    expect(MurmurHash.v3('Some Larger String!', 123), 3193508780);
  });

  test('timestamp', () {
    expect(MurmurHash.v3('2021-03-12T14:03:18.903Z-0000-00000000000000hi', 0),
        3849833620);
  });
}
