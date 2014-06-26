part of isaac;

class Index extends Dash.EntityObserverProcessor {
  List<Dash.Entity> staticCircleEntities = new List<Dash.Entity>();
  List<Dash.Entity> dynamicCircleEntities = new List<Dash.Entity>();
  List<Dash.Entity> staticPolygonEntities = new List<Dash.Entity>();
  List<Dash.Entity> dynamicPolygonEntities = new List<Dash.Entity>();
  
  bool match(Dash.Entity entity) {
    return entity.has(CircleCollider) || entity.has(PolygonCollider);
  }
  
  void onAddition(Dash.Entity entity) {
    getList(entity).add(entity);
  }
  
  void onRemoval(Dash.Entity entity) {
    getList(entity).remove(entity);
  }
  
  List<Dash.Entity> getList(Dash.Entity entity) {
    if(entity.has(PolygonCollider)) {
      if(entity.has(VelocityAspect)) {
        return dynamicPolygonEntities;
      } else {
        return staticPolygonEntities;
      }
    } else {
      if(entity.has(VelocityAspect)) {
        return dynamicCircleEntities;
      } else {
        return staticCircleEntities;
      } 
    }
  }
}
