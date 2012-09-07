class HomeController < ApplicationController
  def index
    if (Cache.get 'RefSet:all').nil?
      @sets = RefSet.find_by_sql("SELECT Set_Code, Set_Exp
      FROM
      Ref_Set
      WHERE
      Discipline = 'C' 
      AND
      {fn LEFT(Lab_Section_Row_ID,9)} ='CHEMHRT||'
      AND
      Allow_Requests = 'Y'")
      Cache.put 'RefSet:all', @sets
    else
    	  @sets = Cache.get 'RefSet:all'
    end
      
  respond_to do |format|
    format.html # index.html.erb
    format.xml  { render :xml => @sets }
  end
  
  end

end
