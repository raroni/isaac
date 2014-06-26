part of isaac;

class PositionAspect extends Dash.Aspect {
  Dash.Point2D position = new Dash.Point2D.zero();
  
  set x (x) => position[0] = x;
  set y (y) => position[1] = y;
  num get x => position[0];
  num get y => position[1];
}
