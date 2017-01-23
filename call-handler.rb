require 'rubygems'
require 'sinatra'
require 'twilio-ruby'

get '/call-handler' do
  Twilio::TwiML::Response.new do |r|
  	r.Gather numDigits: '1', action: '/handle-gather', timeout: '10', method: 'get' do |g|
    	g.Say 'Welcome to email without typing. 
    	Press 1 to send an email.
      Press 2 for more information.'
    end
    r.Say "We didn't receive any key presses. Goodbye!"
  end.text
end

get 'handle-gather' do
	if params['Digits'] == '1'
		response = Twilio::TwiML::Response.new do |r|
			r.Say 'After the beep, please say who you want to 
			send a message to, and then recite your message. 
			There will be up to 2 minutes of recording.'
			r.Record maxLength: '120', action: '/call-handler/handle-record', method: 'get'
		end.text
	elsif params['Digits'] == '2'
		Twilio::TwiML::Response.new do |r|
			r.Say "Hi, I'm Matt, the creator of Email Without Typing. 
			This service is meant to help people who want to send email 
			but can't or don't want to type it. If you have any 
			questions, call back, press 1, and leave a message 
			with your question. We'll get back to you as soon as we can!"
		end.text
	else
		response = Twilio::TwiML::Response.new do |r|
			r.Say 'Please enter a 1 or a 2.'
		end.text		
		redirect '/call-handler'
	end
end

get '/call-handler/handle-record' do 
	Twilio::TwiML::Response.new do |r|
		r.Say "Thank you for recording a message! We will 
		send that email or call you with questions within a day."
	end.text
end