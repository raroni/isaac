part of isaac;

class Collision extends Dash.Event {
  Dash.Entity entity1;
  Dash.Entity entity2;
  Dash.Vector2 separation;
  
  Collision(Dash.Entity this.entity1, Dash.Entity this.entity2, Dash.Vector2 this.separation) { }
}
