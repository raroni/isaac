part of isaac;

class RequestHandling {
  Index index;
  Dash.EventManager eventManager;
  Dash.EventSubscriptionManager eventSubscriptionManager;
  List<Request> requests = new List<Request>();
  int tempID = 0; // needs proper id pool based solution
  
  RequestHandling(Index this.index);
  
  void initialize() {
    eventSubscriptionManager = new Dash.EventSubscriptionManager(eventManager);
    eventSubscriptionManager.add(Request, saveRequest);
  }
  
  void update(Dash.Update update) {
    for(var request in requests) {
      var result = findEntity(request.position);
      var response = new Response(request.id, result); // using null for temp testing
      eventManager.emit(response);
    }
    requests.clear();
  }
  
  Dash.Entity findEntity(Dash.Point2D position) {
    var entity = findEntityByCircleEntities(position, index.dynamicCircleEntities);
    if(entity != null) return entity;
    
    entity = findEntityByCircleEntities(position, index.staticCircleEntities);
    if(entity != null) return entity;
    
    entity = findEntityByPolygonEntities(position, index.staticPolygonEntities);
    if(entity != null) return entity;
    
    entity = findEntityByPolygonEntities(position, index.dynamicPolygonEntities);
    return entity;
  }
  
  Dash.Entity findEntityByCircleEntities(Dash.Point2D position, List<Dash.Entity> entities) {
    for(var entity in entities) {
      var circleCollider = entity.getAspect(CircleCollider);
      var positionAspect = entity.getAspect(PositionAspect);
      var squaredDistance = position.getSquaredDistance(positionAspect.position);
      if(squaredDistance <= circleCollider.radius*circleCollider.radius) return entity;
    }
    return null;
  }
  
  Dash.Entity findEntityByPolygonEntities(Dash.Point2D position, List<Dash.Entity> entities) {
    for(var entity in entities) {
      var positionAspect = entity.getAspect(PositionAspect);
      var localPosition = position - positionAspect.position;
      var polygonCollider = entity.getAspect(PolygonCollider);
      var inside = true; 
      for(var line in polygonCollider.polygon.lines) {
        var d = (localPosition[0]-line.start[0])*(line.end[1]-line.start[1]) - (localPosition[1]-line.start[1])*(line.end[0]-line.start[0]);
        if(d >= 0) {
          inside = false;
          break;
        }
      }
      if(inside) return entity;
    }
    return null;
  }
  
  void saveRequest(Request request) {
    request.id = tempID++;
    requests.add(request);
  }
}
