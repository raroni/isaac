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
      var response = new Response(request.id, null); // using null for temp testing
      eventManager.emit(response);
    }
    requests.clear();
  }
  
  void saveRequest(Request request) {
    request.id = tempID++;
    requests.add(request);
  }
}
