library pair_cache_test;

import 'package:unittest/unittest.dart';
import 'package:isaac/isaac.dart';

class Dummy { }

main() {
  test("#contains", () {
    var dummy1 = new Dummy();
    var dummy2 = new Dummy();
    var dummy3 = new Dummy();
    var dummy4 = new Dummy();
    
    var cache = new PairCache<Dummy>();
    cache.add(dummy1, dummy2);
    cache.add(dummy1, dummy3);
    
    expect(cache.contains(dummy1, dummy2), isTrue);
    expect(cache.contains(dummy2, dummy1), isTrue);
    expect(cache.contains(dummy1, dummy3), isTrue);
    expect(cache.contains(dummy3, dummy1), isTrue);
    
    expect(cache.contains(dummy1, dummy4), isFalse);
    expect(cache.contains(dummy4, dummy1), isFalse);
  });
  
  test("#clears", () {
    var dummy1 = new Dummy();
    var dummy2 = new Dummy();
    var cache = new PairCache<Dummy>();
    cache.add(dummy1, dummy2);
    cache.clear();
    expect(cache.contains(dummy1, dummy2), isFalse);
  });
}
