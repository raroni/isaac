part of isaac;

class Response extends Dash.Event {
  int requestID;
  Dash.Entity result;
  
  Response(int this.requestID, Dash.Entity this.result);
}
