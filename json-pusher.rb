require 'rubygems'
require 'sinatra'
require 'pusher'
require 'redis'

Pusher.app_id = 2192
Pusher.key = 'c4d8da3b6c36091f0ac4'
Pusher.secret = '50d3a48cd3e7133e7f55'

def db
  begin
    # Uncomment to enable Redis
    # @@db ||= Redis.new
    nil
  rescue
    msg = "I couldn't connect to Redis, so I won't be storing the last messages for this channel.\nTo enable it, install Redis, run 'redis-server' and retry."
    @@display_once ||= puts(msg) || true
  end
end

get '/' do
  "<p>This app echoes whatever you POST into /:channel to Pusher.</p>"
end

post '/' do
  "Please post to a channel, as in /channel_name\n"
end

get '/:channel/last_messages.js' do
  if db
    <<-EOS
      document.on("dom:loaded", function(){

        last_messages = (#{db["channels/#{params[:channel]}/last"] || "[]"});
        last_messages.each(function(m) {
          console.log("Loading recent message " + m.id)
          delete m.id
          messages.set(m.id, m)
        })

      })
    EOS
  end
end

get '/:channel' do
  send_payload(params)
end

post '/:channel' do
  send_payload(params)
end

def send_payload(data)
  Pusher['test_channel'].trigger('syncable', data)

  save_to_redis(params) if params[:id] && params[:channel]

  "JSON sent: #{JSON.dump(params)}\n"
end

def save_to_redis(params)
  if db
    last_messages = JSON.parse(db["channels/#{params[:channel]}/last"] || "[]")
    # Keep only the latest 20 messages
    last_messages.shift if last_messages.size == 19
    # Add the latest one
    last_messages.push(params)
    # Save to Redis
    db["channels/#{params[:channel]}/last"] = JSON.dump(last_messages)

    # Save this key in Redis
    key = "channels/#{params[:channel]}/payloads/#{params[:id]}"
    puts "Saving to Redis: #{key}"
    db[key] = JSON.dump(params)
  end
end
