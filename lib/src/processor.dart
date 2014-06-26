part of isaac;

class Processor extends Dash.Processor {
  Movement movement = new Movement();
  CollisionDetection collisionDetection = new CollisionDetection();
  CollisionResolution collisionResolution = new CollisionResolution();
  
  void onProcessorInitialized() {
    // setup some registry that maintains registry of colliders 
    // in turn, CollisionDetection and RequestHandling can use this
    // registry to do their job
    // That way, RequestHandling does not have to maintain an identical
    // copy of the list
    
    movement.eventManager = eventManager;
    movement.initialize();
    
    collisionDetection.eventManager = eventManager;
    collisionDetection.initialize();
    
    collisionResolution.eventManager = eventManager;
    collisionResolution.initialize();
  }
  
  void update(Dash.Update update) {
    movement.receiveUpdate(update);
    collisionDetection.receiveUpdate(update);
    collisionResolution.receiveUpdate(update);
  }
}
