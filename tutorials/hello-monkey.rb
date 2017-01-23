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
    	g.Say 'Press 2 to record your own monkey howl'
    	g.Say 'Press any other key to start over.'
    end
  end.text
end

# get '/hello-monkey/handle-gather' do
# 	redirect '/hello-monkey' unless ['1','2'].include?(params['Digits'])
# 	if params['Digits'] == 1
# 		response = Twilio::TwiML::Response.new do |r|
# 			r.Dial '+13105551212' ## didn't work for me, need another phone
# 			r.Say 'The call failed or the remote party hung up. Goodbye!'
# 		end.text
# 	elsif params['Digits'] == 2
# 		Twilio::TwiML::Response.new do |r|
# 			r.Say 'Record your monkey howl after the tone.'
# 			r.Record maxLength: '30', action: '/hello-monkey/handle-record', method: 'get'
# 		end.text
# 	end
# end

get '/hello-monkey/handle-gather' do
	Twilio::TwiML::Response.new do |r|
		r.Say 'Record your monkey howl after the tone.'
		r.Record maxLength: '30', action: '/hello-monkey/handle-record', method: 'get'
	end.text
end

get '/hello-monkey/handle-record' do 
	Twilio::TwiML::Response.new do |r|
		r.Say 'Listen to your monkey howl.'
		r.Play params['RecordingUrl']
		r.Say 'Goodbye.'
	end.text
end