part of isaac;

class CollisionDetection extends Dash.Processor {
  PairCache<Dash.Entity> pairCache = new PairCache<Dash.Entity>();
  Index index;
  
  CollisionDetection(Index this.index);
  
  void onProcessorInitialized() {
    eventSubscriptionManager.add(Dash.Update, receiveUpdate);
  }
  
  void receiveUpdate(Dash.Update update) {
    for(var entity1 in index.dynamicCircleEntities) {
      for(var entity2 in index.dynamicCircleEntities) {
        if(entity1 != entity2 && !pairCache.contains(entity1, entity2)) {
          testCircles(entity1, entity2);
          pairCache.add(entity1, entity2);
        }
      }
      for(var entity2 in index.staticCircleEntities) {
        testCircles(entity1, entity2);
      }
      for(var entity2 in index.dynamicPolygonEntities) {
        testCirclePolygon(entity1, entity2);
      }
      for(var entity2 in index.staticPolygonEntities) {
        testCirclePolygon(entity1, entity2);
      }
    }
    pairCache.clear();
    
    for(var entity1 in index.dynamicPolygonEntities) {
      for(var entity2 in index.dynamicPolygonEntities) {
        if(entity1 != entity2 && !pairCache.contains(entity1, entity2)) {
          testPolygons(entity1, entity2);
          pairCache.add(entity1, entity2);
        }
      }
      for(var entity2 in index.staticPolygonEntities) {
        testPolygons(entity1, entity2);
      }
      for(var entity2 in index.staticCircleEntities) {
        testCirclePolygon(entity2, entity1);
      }
    }
    pairCache.clear();
  }
  
  void testCircles(Dash.Entity entity1, Dash.Entity entity2) {
    var positionAspect1 = entity1.getAspect(PositionAspect);
    var positionAspect2 = entity2.getAspect(PositionAspect);
    var centerDif = positionAspect1.position - positionAspect2.position;
    
    var distance = centerDif.length;
    
    var collider1 = entity1.getAspect(CircleCollider);
    var collider2 = entity2.getAspect(CircleCollider);
    var overlap = collider1.radius+collider2.radius-distance;
    if(overlap > 0) {
      var separation = new Dash.Vector2.normalized(centerDif)*overlap;
      eventManager.emit(new Collision(entity1, entity2, separation));
    }
  }
  
  void testPolygons(Dash.Entity entity1, Dash.Entity entity2) {
    var separation1 = findSmallestPolygonSeparation(entity1, entity2);
    if(separation1 == null) return;
    var separation2 = findSmallestPolygonSeparation(entity2, entity1);
    if(separation2 == null) return;
    
    var separation;
    if(separation1.squaredLength < separation2.squaredLength) {
      separation = separation1*-1;
    } else {
      separation = separation2;
    }
    
    eventManager.emit(new Collision(entity1, entity2, separation));
  }
  
  Dash.Vector2 findSmallestPolygonSeparation(Dash.Entity entity1, Dash.Entity entity2) {
    var smallestSeparationDistance, smallestSeparationDirection;
    
    var collider1 = entity1.getAspect(PolygonCollider);
    var collider2 = entity2.getAspect(PolygonCollider);
    
    var polygon1 = collider1.polygon;
    var polygon2 = collider2.polygon.createClone();
    var positionAspect1 = entity1.getAspect(PositionAspect);
    var positionAspect2 = entity2.getAspect(PositionAspect);
    polygon2.translate(positionAspect2.position - positionAspect1.position);
    
    for(var normal in collider1.polygon.normals) {
      var projection1 = polygon1.project(normal);
      var projection2 = polygon2.project(normal);
      
      if(projection1.include(projection2)) {
        // Not implemented yet.
      } else {
        if(!projection1.overlap(projection2)) return null;
        var overlap = projection1.getOverlap(projection2);
        if(smallestSeparationDistance == null || smallestSeparationDistance.abs() > overlap.abs()) {
          smallestSeparationDistance = overlap;
          smallestSeparationDirection = normal;
        }
      }
    }
    
    var separation = smallestSeparationDirection * smallestSeparationDistance;
    return separation;
  }
  
  void testCirclePolygon(Dash.Entity circleEntity, Dash.Entity polygonEntity) {
    var circlePositionAspect = circleEntity.getAspect(PositionAspect);
    var polygonPositionAspect = polygonEntity.getAspect(PositionAspect);
    
    var circlePositionRelativeToPolygon = circlePositionAspect.position - polygonPositionAspect.position;
    
    var polygonCollider = polygonEntity.getAspect(PolygonCollider);
    var polygon = polygonCollider.polygon;
    
    var shortestSquaredDistance = double.MAX_FINITE;
    var closestLineIndex;
    
    for(var i=0; polygon.lines.length>i; i++) {
      var line = polygon.lines[i];
      var squaredDistance = line.getSquaredDistanceToPoint(circlePositionRelativeToPolygon);
      if(squaredDistance < shortestSquaredDistance) {
        shortestSquaredDistance = squaredDistance;
        closestLineIndex = i; 
      }
    }
    
    var circleCollider = circleEntity.getAspect(CircleCollider);
    var distance = Math.sqrt(shortestSquaredDistance);
    if(distance <= circleCollider.radius) {
      var normal = polygon.normals[closestLineIndex];
      var separation = normal * (circleCollider.radius-distance);
      eventManager.emit(new Collision(circleEntity, polygonEntity, separation));
    }
  }
}
