import ballerina/http;
import ballerina/log;
import ballerina/io;
import ballerina/config;

string accessToken = config:getAsString("ACCESS_TOKEN");

endpoint http:Client fbBot {
    url:"https://graph.facebook.com",
     cache: { enabled: false }
};

@http:ServiceConfig {
    basePath: "/webhook"
}
service<http:Service> hello bind { port: 9090 } {
    @http:ResourceConfig {
        path: "/",
        methods: ["GET"]
    }
    sayHello(endpoint caller, http:Request req) {
        map<string> challenge = req.getQueryParams();
        string? country = challenge["hub.challenge"];
        io:println(country);
        http:Response res = new;
        caller->respond(untaint country) but { error e => log:printError(
                           "Error sending response", err = e) };
    }

     @http:ResourceConfig {
        path: "/",
        methods: ["POST"]
    }
    sayHello2(endpoint caller, http:Request req) {
      //   string details = check req.getPayloadAsString();
      //   io:println(details);
        json messengerPayload = check req.getJsonPayload();
         string  sender = untaint messengerPayload.entry[0].messaging[0].sender.id.toString();
        io:print(sender);
// string recipientId = jsons:getString(messengerPayload,"$.entry[0]messaging[0].sender.id");
//         system:println(recipientId);
//         string messageTxt = jsons:getString(messengerPayload,"$.entry[0]messaging[0].message.text");
//         system:println(messageTxt);

        var response = check fbBot -> post("/v2.9/me/messages?access_token=" + accessToken, {
  "recipient":{
    "id":sender
  },
  "message":{
    "text":"hello, world!"
  }
});
        http:Response res = new;
        caller->respond(untaint response) but { error e => log:printError(
                           "Error sending response", err = e) };
    }
}

