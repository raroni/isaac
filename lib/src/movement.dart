part of isaac;

class Movement extends Dash.EntityProcessor {
  bool match(Dash.Entity entity) {
    return entity.has(VelocityAspect);
  }
  
  void updateEntity(Dash.Entity entity, Dash.Update update) {
    var velocityAspect = entity.getAspect(VelocityAspect);
    var positionAspect = entity.getAspect(PositionAspect);
    positionAspect.position.add(velocityAspect.velocity);
  }
}
