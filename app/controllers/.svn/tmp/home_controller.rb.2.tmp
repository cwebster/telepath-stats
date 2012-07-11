class HomeController < ApplicationController
  def index
   @sets = RefSet.all
 
  respond_to do |format|
    format.html # index.html.erb
    format.xml  { render :xml => @sets }
  end
  
  end

end
