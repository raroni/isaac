part of isaac;

class CollisionResolution extends Dash.Processor {
  List<Collision> pendingCollisions = new List<Collision>();
  
  void onProcessorInitialized() {
    eventSubscriptionManager.add(Collision, receiveCollision);
    eventSubscriptionManager.add(Dash.Update, receiveUpdate);
  }
  
  void receiveCollision(Collision collision) {
    pendingCollisions.add(collision);
  }
  
  void receiveUpdate(Dash.Update update) {
    for(var collision in pendingCollisions) {
      var entity1Static = !collision.entity1.has(VelocityAspect);
      var entity2Static = !collision.entity2.has(VelocityAspect);
      
      var baseChange = collision.separation*1.01;
      
      if(entity1Static) {
        move(collision.entity2, baseChange * -1);
      }
      else if(entity2Static) {
        move(collision.entity1, baseChange);
      } else {
        var halfSeparation = baseChange*0.5;
        move(collision.entity1, halfSeparation);
        move(collision.entity2, halfSeparation * -1);
      }
    }
    
    pendingCollisions.clear();
  }
  
  void move(Dash.Entity entity, Dash.Vector2 change) {
    var positionAspect = entity.getAspect(PositionAspect);
    positionAspect.position.add(change);
    var velocityAspect = entity.getAspect(VelocityAspect);
    if(change[0].abs() > change[1].abs()) {
      velocityAspect.velocity[0] = 0;
      velocityAspect.velocity[1] *= 0.8;
    } else {
      velocityAspect.velocity[1] = 0;
      velocityAspect.velocity[0] *= 0.8;
    }
  }
}
