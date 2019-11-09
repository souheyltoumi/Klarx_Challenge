# this is a simple model example
# check https://datamapper.org/getting-started.html
require 'data_mapper'
require 'sinatra'
require  'dm-migrations'
class Exchange
    include DataMapper::Resource
  
    property :id,         Serial    # An auto-increment integer key
    property :AmountFrom,      Text  , required: true   # A varchar type string, for short strings
	property :From,       Text    , required: true   # A text block, for longer string data.
	property :To,       Text    , required: true   # A text block, for longer string data.
    property :AmountTo,      Text  , required: true   # A varchar type string, for short strings

    property :done_at, DateTime , required: true  # A DateTime, for any date you might like.
  end
  DataMapper::Logger.new($stdout, :debug)

  DataMapper.finalize
  DataMapper.auto_migrate!

  DataMapper.auto_upgrade!
