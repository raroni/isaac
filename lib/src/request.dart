part of isaac;

class Request extends Dash.Event {
  int id;
  Dash.Point2D position;
  
  Request(Dash.Point2D this.position);
}
