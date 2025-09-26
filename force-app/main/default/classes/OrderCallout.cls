public with sharing class OrderCallout {
    @future(callout=true)
    public static void sendOrderToExternal(Id orderId) {
        Order__c ord = [SELECT Id, Name, Status__c FROM Order__c WHERE Id = :orderId];

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        // Using Named Credential
        req.setEndpoint('callout:ExternalOrderAPI/orders');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        
        // Convert to JSON
        Map<String, Object> body = new Map<String, Object>();
        body.put('orderId', ord.Id);
        body.put('status', ord.Status__c);
        req.setBody(JSON.serialize(body));

        HttpResponse res = http.send(req);
        System.debug('Response: ' + res.getBody());
    }
}
