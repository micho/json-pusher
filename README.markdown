JSON-Pusher
=========

#### Allow you to broadcast events with Pusherapp from JS ####

Pusherapp.com allows you to receive HTTP Push notifications from any web page.
But it's not easy to push data from a JS client to the web, unless you have a web server.

This utility is a most basic web server that allows you to post to Pusherapp from JS.

If Redis is enabled (optional), it will also store the latest 20 messages for each channel.


Using JSON-Pusher
---------------

You can deploy JSON-Pusher locally or in Heroku. To deploy locally, just run

    rackup config.ru

For Heroku, create an app and push this repository to it.

Once the app is running, you can GET or POST routes like /channel_name.
Anything that you send will be broadcasted through all the clients listening.


Author and License
---------------

Pablo Villalba <pablo@teambox.com>
As an extraction from [Teambox project management system](http://teambox.com) and the
Syncable JS library.

Licensed under the MIT license. Enjoy!
