part of isaac;

class Processor extends Dash.Processor {
  Movement movement = new Movement();
  Index index = new Index();
  CollisionDetection collisionDetection;
  CollisionResolution collisionResolution = new CollisionResolution();
  RequestHandling requestHandling;
  
  Processor() {
    collisionDetection = new CollisionDetection(index);
    requestHandling = new RequestHandling(index);
  }
  
  void onProcessorInitialized() {
    index.eventManager = eventManager;
    index.initialize();
    
    movement.eventManager = eventManager;
    movement.initialize();
    
    collisionDetection.eventManager = eventManager;
    collisionDetection.initialize();
    
    collisionResolution.eventManager = eventManager;
    collisionResolution.initialize();
    
    requestHandling.eventManager = eventManager;
    requestHandling.initialize();
    
    eventSubscriptionManager.add(Dash.Update, update);
  }
  
  void update(Dash.Update update) {
    movement.update(update);
    collisionDetection.receiveUpdate(update);
    collisionResolution.receiveUpdate(update);
    requestHandling.update(update);
  }
}
