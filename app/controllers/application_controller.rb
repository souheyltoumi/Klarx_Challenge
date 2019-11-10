require 'json'
require 'money/bank/currencylayer_bank'
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
		# Minimal requirements
	mclb = Money::Bank::CurrencylayerBank.new

	mclb.access_key = 'b70a394018b7398799fd2e7a14a89268'

# Update rates (get new rates from remote if expired or access rates from cache)
	mclb.update_rates

# Force update rates from remote and store in cache
# mclb.update_rates(true)

# (optional)
# Set the base currency for all rates. By default, USD is used.
# CurrencylayerBank only allows USD as base currency for the free plan users.

# (optional)
# Set the seconds after than the current rates are automatically expired
# by default, they never expire, in this example 1 day.

# (optional)
# Use https to fetch rates from CurrencylayerBank
# CurrencylayerBank only allows http as connection for the free plan users.
		mclb.update_rates # Update rates (get new rates from remote if expired or access rates from cache)
	Money.default_bank = mclb	
	Money.locale_backend = :i18n
	I18n.enforce_available_locales = false
		

	 AmountFrom=params['AmountFrom'].to_i
	 from1=params['EURO']
	 from2=params['CHF']
	 from3=params['USD']
	 to1=params['EURO1']
	 to2=params['CHF1']
	 to3=params['USD1']
	if from1.to_s=="on"
   		from="EUR"
	elsif from2.to_s=="on"
		from="CHF"
	elsif from3.to_s=="on"
		from="USD"
	end
	if to1.to_s=="on"
		to="EUR"
 	elsif to2.to_s=="on"
	 	to="CHF"
 	elsif to3.to_s=="on"
	 	to="USD"
	 end
	
		AmountTo=Money.new( AmountFrom* 100, from.to_s).exchange_to(to).format 

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