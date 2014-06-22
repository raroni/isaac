part of isaac;

class Processor extends Dash.Processor {
  Movement movement = new Movement();
  CollisionDetection collisionDetection = new CollisionDetection();
  CollisionResolution collisionResolution = new CollisionResolution();
  
  void onProcessorInitialized() {
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
