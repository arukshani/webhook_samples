import ballerina/http;
import ballerina/log;
import ballerina/io;
import ballerina/config;

endpoint http:Client clientEP {
    url:"https://graph.facebook.com",
    cache: { enabled: false }
};

string accessToken = config:getAsString("ACCESS_TOKEN");

@http:ServiceConfig {
    basePath: "/ff"
}
service<http:Service> hello bind { port: 9090 } {
    @http:ResourceConfig {
        path: "/",
        methods: ["GET"]
    }
    sayHello(endpoint caller, http:Request req) {
        var resp = clientEP->get("/v3.1/me?access_token=" + accessToken);
    match resp {
        http:Response res=> {
            string ff = check res.getPayloadAsString();
            io:print(ff);
        }
        error e=> {
            
        }
    }
        http:Response res = new;
        caller->respond(untaint res) but { error e => log:printError(
                           "Error sending response", err = e) };
    }

     friendCount(endpoint caller, http:Request req) {
        var resp = clientEP->get("/v3.1/me/friends?access_token=" + accessToken);
    match resp {
        http:Response res=> {
            string ff = check res.getPayloadAsString();
            io:print(ff);
        }
        error e=> {
            
        }
    }
        http:Response res = new;
        caller->respond(untaint res) but { error e => log:printError(
                           "Error sending response", err = e) };
    }

updateStatus(endpoint caller, http:Request req) {
    http:Request fff = new;
    fff.setPayload("message=Hello World test from ballerina. please ignore!");
        var resp = clientEP->post("/v3.1/me/feed?access_token="+ accessToken, fff);
    match resp {
        http:Response res=> {
            string ff = check res.getPayloadAsString();
            io:print(ff);
        }
        error e=> {
            
        }
    }
        http:Response res = new;
        caller->respond(untaint res) but { error e => log:printError(
                           "Error sending response", err = e) };
    }

    shareLink(endpoint caller, http:Request req) {
        var resp = clientEP->post("/v3.1/me/feed?link=https://ballerina.io/&access_token="+ accessToken, "");
    match resp {
        http:Response res=> {
            string ff = check res.getPayloadAsString();
            io:print(ff);
        }
        error e=> {
            
        }
    }
        http:Response res = new;
        caller->respond(untaint res) but { error e => log:printError(
                           "Error sending response", err = e) };
    }

}

