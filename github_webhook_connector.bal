
import ballerina/log;
import ballerina/websub;
import wso2/twitter;
import maryamzi/github;
import ballerina/io;


endpoint github:WebhookListener githubListenerEP {
    port: 8181
};

// endpoint twitter:Client twitterClient {
//     clientId:"<CONSUMER_ID>",
//     clientSecret:"<CONSUMER_SECRET>",
//     accessToken:"<ACCESS_TOKEN>",
//     accessTokenSecret:"<ACCESS_TOKEN_SECRET>"
// };


@websub:SubscriberServiceConfig {
    path: "/github",
    secret: "SKMdsFLs293nG"
}
service<github:WebhookService> githubWebhook bind githubListenerEP {

  onPing(websub:Notification notification, github:PingEvent event) {
      io:println("GitHub Notification Received, X-GitHub-Event header: ", notification.getHeaders("X-GitHub-Event"));
      io:println("Webhook added with URL: ", event.hook.config.url);
  }

  onWatch(websub:Notification notification, github:WatchEvent event) {
       json jsonPayload = check notification.getJsonPayload();
       string tweetBody = jsonPayload.sender.login.toString()
                               + " just starred repository "
                               + jsonPayload.repository.full_name.toString() + "!" +
                               " Tweeted via webhook ;)";
        io:print(tweetBody);                       
    //    twitter:Status twitterStatus = check twitterClient->tweet(tweetBody, "", "");
    //    log:printInfo("Tweet ID: " + <string> twitterStatus.id
    //                               + ", Tweet: " + twitterStatus.text);
    // io:print("github notification received!");
    // io:print(jsonPayload["action"]);
  }
}


