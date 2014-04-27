part of isaac;

class VelocityAspect extends Dash.Aspect {
  Dash.Vector2 velocity = new Dash.Vector2.zero();
  num limit = 1;
  
  void reset() {
    velocity.reset();
  }
}
