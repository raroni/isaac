part of isaac;

class Movement extends Dash.EntityObserverProcessor {
  bool match(Dash.Entity entity) {
    return entity.has(VelocityAspect);
  }
  
  void update(Dash.Update update) {
    for(var entity in entities) {
      var velocityAspect = entity.getAspect(VelocityAspect);
      var positionAspect = entity.getAspect(PositionAspect);
      positionAspect.position.add(velocityAspect.velocity);
    }
  }
}
