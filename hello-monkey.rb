require 'rubygems'
require 'sinatra'
require 'twilio-ruby'

get '/hello-monkey' do
	people = {
		'+14154848153' => 'Dennis'
	}
	name = people[params['From']] || "you goof"
  Twilio::TwiML::Response.new do |r|
    r.Say "Hello #{name}"
    r.Play 'http://demo.twilio.com/hellomonkey/monkey.mp3'
    r.Gather numDigits: '1', action: '/hello-monkey/handle-gather', method: 'get' do |g|
    	g.Say 'To speak to a real monkey, press 1.'
    	g.Say 'Press any other key to start over.'
    end
  end.text
end

get '/hello-monkey/handle-gather' do
	redirect '/hello-monkey' unless params['Digits'] == '1'
	Twilio::TwiML::Response.new do |r|
		r.Dial '+13105551212' ## Connect to demo of Koko
		r.Say 'The call failed or the remote party hung up. Goodbye!'
	end.text
end
