
require 'rest-client'
require 'json'
class ApplicationController < Sinatra::Base
	# This configuration part will inform the app where to search for the views and from where it will serve the static files
  	configure do
    	set :views, "app/views"
    	set :public_dir, "public"
	  end
	


	  get '/' do


   		erb :index
	  end
	 
   	  
	  get '/dash' do


		erb :print
   	  end
	  post '/todo' do
		response = RestClient::Request.new(
   		:method => :get,
  	 	:url => 'http://apilayer.net/api/live?access_key=b70a394018b7398799fd2e7a14a89268&currencies=EUR,CHF&source=USD&format=1',
   		:verify_ssl => false
		).execute
		results = JSON.parse(response.to_str)
		usd_euro=results['quotes']['USDEUR']

		usd_chf=results['quotes']['USDCHF']


	 AmountFrom=params['AmountFrom'].to_f
	 from1=params['EURO']
	 from2=params['CHF']
	 from3=params['USD']
	 to1=params['EURO1']
	 to2=params['CHF1']
	 to3=params['USD1']
	if from1.to_s=="on"
   		from="EURO"
	elsif from2.to_s=="on"
		from="CHF"
	elsif from3.to_s=="on"
		from="USD"
	end
	if to1.to_s=="on"
		to="EURO"
 	elsif to2.to_s=="on"
	 	to="CHF"
 	elsif to3.to_s=="on"
	 	to="USD"
	 end
	if from.to_s=="EURO" and to.to_s=="USD"
		AmountTo=AmountFrom/usd_euro.to_f
	elsif from.to_s=="EURO" and to.to_s=="CHF"
		AmountTo=AmountFrom/usd_euro.to_f

		AmountTo=AmountFrom*usd_chf.to_f
	elsif from.to_s=="USD" and to.to_s=="CHF"
		AmountTo=AmountFrom*usd_chf.to_f
	elsif from.to_s=="USD" and to.to_s=="EURO"
		AmountTo=AmountFrom*usd_euro.to_f
	elsif from.to_s=="CHF" and to.to_s=="EURO"
		AmountTo=AmountFrom/usd_chf.to_f
		AmountTo=AmountFrom*usd_euro.to_f

	elsif from.to_s=="CHF" and to.to_s=="CHF"
		AmountTo=AmountFrom
	elsif from.to_s=="USD" and to.to_s=="USD"
		AmountTo=AmountFrom
	elsif from.to_s=="EURO" and to.to_s=="EURO"
		AmountTo=AmountFrom
	elsif from.to_s=="CHF" and to.to_s=="USD"
		AmountTo=AmountFrom/usd_chf.to_f
		
	end


	

	 
	 

	 done=Time.now
	 @post = Exchange.create(
		:AmountFrom      => AmountFrom.to_s,
		:From      =>from,
		:To       => to,
		:AmountTo       => AmountTo.to_s,
		:done_at => Time.now
	  )
	  
	  # Or new gives you it back unsaved, for more operations
	 @post.save
	 def global
		@@variable=AmountTo
			end
	 redirect "/dash"	
end
get '/history' do

	@todos = Exchange.all
	erb :history 
end


end