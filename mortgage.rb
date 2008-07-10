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
  (r / (1 - (1+r) ** -n)) * p
end

def property_tax(price, rate)
  price * rate / 100.0 / 12
end

helpers do
  # tag helpers
  def stylesheet(path, media = 'screen,projection')
    path << '.css' unless path =~ %r{\Ahttp://|\.css\Z}
    %Q{<link rel="stylesheet" type="text/css" href="#{path}" media="#{media}" />}
  end
  
  def field(name, label = name.to_s.titleize)
    haml :field, :locals => { :name => CGI.escape(name.to_s), :label => label }, :layout => false
  end
  
  # text formatting helpers
  def numerify(n)
    if n
      q, r = ('%.2f' % n).split('.')
      [q.reverse.scan(/\d{1,3}/).join(',').reverse, r].join('.')
    end
  end
end

use_in_file_templates!

__END__

## layout
!!! XML
!!!
%html{ :xmlns => 'http://www.w3.org/1999/xhtml', :'xml:lang' => 'en', :lang => 'en' }
  %head
    %meta{ :'http-equiv' => 'Content-Type', :content => 'text/html;charset=UTF-8' }
    %title Mort - the Mortgage Calculator
    = stylesheet '/css/screen'
    = stylesheet '/css/print', 'print'
    /[if IE]
      = stylesheet '/css/ie'
    = stylesheet '/css/style'
  %body
    .container
      #bd.span-24
        = yield
      #ft.span-24
        %p
          Copyright &copy; 2008
          %a{ :href => 'http://urgetopunt.org/~jparker/' } John Parker
          |
          %a{ :href => 'http://validator.w3.org/check?uri=referer' } Valid XHTML 1.0 Transitional

## field
%p
  %label{ :for => name }= label
  %input{ :type => 'text', :value => numerify(instance_variable_get("@#{name}")), :name => name, :id => name }

## index
%form{ :action => '/', :method => :post }
  .span-4
    - if @mortgage && !@mortgage.nan?
      %dl
        %dt Mortgage
        %dd= numerify(@mortgage)
        %dt Property Tax
        %dd= numerify(@property_tax)
        %dt HOA
        %dd= numerify(@hoa)
        %dt Total
        %dd= numerify(@mortgage + @property_tax + @hoa)
  .span-20.last
    = field :irate, 'Interest Rate [e.g., 6.25]'
    = field :term, 'Term (years) [e.g., 30]'
    = field :price, 'Purchase Price [e.g., 300,000.00]'
    = field :down, 'Down Payment [e.g., 60,000.00]'
    = field :trate, 'Property Tax Rate [e.g., 1.25]'
    = field :hoa, 'HOA Fee, e.g., 400.00'
    %p
      %input{ :type => 'submit', :value => 'Calculate' }
