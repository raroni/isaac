part of isaac;

class PairCache<T> {
  Map<T, Collection.HashSet<T>> map = new Map<T, Collection.HashSet<T>>();
  
  void add(T object1, T object2) {
    addToMap(object1, object2);
    addToMap(object2, object1);
  }
  
  void addToMap(T object1, T object2) {
    var set = map[object1];
    if(set == null) { 
      set = new Collection.HashSet<T>();
      map[object1] = set;
    }
    
    set.add(object2);
  }
  
  bool contains(T object1, T object2) {
    var set = map[object1];
    return set != null && set.contains(object2);
  }
  
  void clear() {
    map.clear();
  }
}
