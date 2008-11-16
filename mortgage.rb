require 'rubygems'
require 'sinatra'
require 'activesupport'

get '/' do
  haml :index
end

post '/' do
  %w[price down term irate trate hoa].each do |var|
    instance_variable_set("@#{var}", params[var].gsub(/[$%,]/, '').to_f)
  end
  
  @mortgage     = mortgage(@price - @down, @irate, @term)
  @property_tax = property_tax(@price, @trate)
  
  haml :index
end

private
def mortgage(principal, rate = 6.25, term = 30)
  r = rate / 100.0 / 12
  p = principal
  n = term * 12
  (r / (1 - (1 + r) ** -n)) * p
end

def property_tax(price, rate)
  price * rate / 100.0 / 12
end

helpers do
  # tag helpers
  def stylesheet(path, options = {})
    options[:media] ||= 'screen,projection'
    %Q{<link href="#{path}" rel="stylesheet" type="text/css" media="#{options[:media]}" />}
  end
  
  def text_field(name, label = name.to_s.titleize)
    haml :text_field, :locals => { :name => CGI.escape(name.to_s), :label => label }, :layout => false
  end
  
  # text formatting helpers
  def numerify(n)
    if n
      q, r = ('%.2f' % n).split('.')
      [q.reverse.scan(/\d{1,3}/).join(',').reverse, r].join('.')
    end
  end
end
