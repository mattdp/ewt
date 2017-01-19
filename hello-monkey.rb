require 'rubygems'
require 'sinatra'
require 'twilio-ruby'

get '/hello-monkey' do
	people = {
		'+14154848153' => 'Dennis'
	}
	name = people[params['From']] || "you goof"
  Twilio::TwiML::Response.new do |r|
    r.Say 'Hello #{name}'
    r.Play 'http://demo.twilio.com/hellomonkey/monkey.mp3'
  end.text
end