class YammerController < ApplicationController

  def initialize
    @method_list_prod = ['api_endpoint',
      ['search','dan'],
      ['messages_from','dan'],
      'users',
      ['get','users'],
      'suggestions',
      'praise',
      ['group','1038538'],
      'groups',
      'messages',
      'messages_sent',
      'messages_received',
      'direct_messages',
      ['about_topic','dan'],
      ['thread','230037480'],
      ['activity','1490093239'],
      'my_feed',
      'adapter',
      'format',
      'parse_response',
      'gateway',
      'proxy',
      'user_agent',
      'instance_values',
      'instance_variable_names',
      'instance_variables'
    ]
    @method_list_dev = ['oauth_token',
      'oauth_token_secret',
      'consumer_key',
      'consumer_secret'
    ]

    if  Rails.env.production?
      @method_list = @method_list_prod
    else
      @method_list = @method_list_prod + @method_list_dev
    end # if

    super
  end # def

  def client
    @yammer_client = new_client
  end # def

  def client_method
    @yammer_client = new_client
    # Trust any method name sent by end-user which is included in @method_list:
    if @method_list.include?(params[:ymeth])
      @output = @yammer_client.send(params[:ymeth].to_sym)
    else
      @output = "We received no output from this client method: #{params[:ymeth]}."
    end # if
  end # def

  def client_method2
    ok_methods = @method_list.select{|meth| meth.class == Array}.map{ |arr| arr[0] }
    if ok_methods.include?(params[:ymeth])
      @yammer_client = new_client
      @output = "You hit client_method2 with #{params.inspect}"
      @output = @yammer_client.send(params[:ymeth].to_sym, params[:ymeth_arg])
    else
      @output = "We received no output from this client method: #{params[:ymeth]}."
    end # if
    render :client_method
  end # def

  def method_list
  end # def

  def yammer_request
    @yammer_client = new_client
    @output = "You hit yammer_request with #{params.inspect}"
    # find_by_id evaporated from API, not sure why.
    # @output = @yammer_client.send(:find_by_id, params[:the_id]) if params[:the_id]
  end # def

  def yammer_open_graph
    @yammer_client = new_client
    @output = "You hit yammer_open_graph with #{params.inspect}"
    # Now I should serve a form asking for:
    # name, email
  end # def

  # POST
  def yammer_og_post
    @yammer_client = new_client
    # A nice feature of the Yammer gem is I dont need to convert my data to JSON.
    # The gem does that for me.
    # All I need to do is create a Ruby-hash-object with data in a structure which mirrors
    # the structure described here:
    # https://developer.yammer.com/opengraph/
    # It is convenient that the syntax I use to create a Ruby-hash-object,
    # is very similar to JSON syntax.
    @og_hash = 
      {activity:
        {actor:
          {name: params[:yname], email: params[:yemail], url: nil}, 
          action: params[:crud_action],
          object:
            {url: params[:yurl], type: "page", title: params[:ytitle], image: params[:yimage]}
        },
      private: true, message: "", users: []
      }

    @output = @yammer_client.post('activity', @og_hash)
  end # def

  private

  def new_client
    Yammer.new(parse_response: true, oauth_token: session[:oauth_token], consumer_key: ENV['YAMMER_KEY'], consumer_secret: ENV['YAMMER_SECRET'] )
  end # def

end # class


