class OutStandingWorkIndexController < ApplicationController

def gen_xml
    @outstanding=OutstandingWorkIndex.find(:all)
end

def statistics

if (Cache.get 'statistics:').nil?
  @statistics = OutstandingWorkIndex.find_by_sql("
    SELECT DISTINCT
      count (rs.Date_Time_Booked_In) AS Number_Outstanding, 
      rs.Set_Code, 
      avg (DATEDIFF('hh',rs.Date_Time_Booked_In,current_timestamp)) as delay,
      owi.Discipline
    FROM
	    Request R,
	    Outstanding_Work_Index owi
	    INNER JOIN Result_Set rs ON (owi.Request_Row_ID = R.Request_Row_ID
                         	AND owi.Request_Row_ID = rs.Request_Row_ID)
    WHERE
	    rs.Date_Time_Authorised Is Null
    GROUP BY
	    rs.Set_Code order by Number_Outstanding DESC")

    Cache.put 'statistics:', @statistics
else
    @statistics = Cache.get 'statistics:'
end
  count = 0
	delay = 0
	numbers = 0
	numb = Array.new
	
	@statistics.each do |statistic|
		if !statistic.delay.nil?
			count = count +1
			numbers = numbers + statistic.Number_Outstanding.to_f		
			numb[count] = statistic.delay.to_f
    end  	
	end
	
	@median = median(numb)
	@median = (@median*100).round/100.0 
 	@mean = mean(numb)
    @mean = (@mean*100).round/100.0 
    @outstanding = numbers
  
  StatHat::API.ez_post_value("Median Wait: ", "craig.webster@heartofengland.nhs.uk", @median.to_i)
  StatHat::API.ez_post_value("Total Number Sets Outstanding: ", "craig.webster@heartofengland.nhs.uk", @outstanding)

	respond_to do |format|
    	format.html # statistics.html.erb
    	format.xml  { render :xml => @statistics }
  end
end

def statistic
	
	if (Cache.get 'statistic:'+ params[:set_code].upcase).nil?
	  @statistic = OutstandingWorkIndex.find_by_sql ["SELECT DISTINCT
	      rs.Set_Code, 
	      R.Specimen_Number , 
	      DATEDIFF('hh',rs.Date_Time_Booked_In,current_timestamp) as HrsIn , 
	      rs.Set_code
	    FROM 
	      Result_Set rs,
	      Request R
	    INNER JOIN Outstanding_Work_Index owi on (owi.Request_Row_ID = R.Request_Row_ID) AND
				  (owi.Request_Row_ID = rs.Request_Row_ID)
			WHERE  
			  rs.Date_Time_Authorised Is Null 
			  and rs.Set_code=?
			  order by 
			  rs.Date_Time_Booked_In ASC", params[:set_code].upcase]
		
		Cache.put 'statistic:'+ params[:set_code].upcase, @statistic
	else
	  @statistic = Cache.get 'statistic:'+ params[:set_code].upcase
	end
	
	if @statistic.empty?
	  
	else
	  
   	@outstanding = @statistic.size
   	hours2 = @statistic.map(&:HrsIn)
   	@median = median(hours2)
    @mean = mean(hours2)
    @mean = (@mean*100).round/100.0 
    @pcttat = (@median/336)*100
    @pcttat = (@pcttat*100).round/100.0 
    
    puts "here i am"
    StatHat::API.ez_post_value("Median TAT: " +params[:set_code].upcase, "craig.webster@heartofengland.nhs.uk", @median.to_i)
    
    StatHat::API.ez_post_value("Number Outstanding: " +params[:set_code].upcase, "craig.webster@heartofengland.nhs.uk", @outstanding.to_i)
    
  end
     @setcode= params[:set_code].upcase
  	
  	respond_to do |format|
      format.html
      format.xml  { render :action => "statistic.xml.builder", :layout => false }
    end

end

def paststats

if (Cache.get 'paststats:'+ params[:set_code].upcase).nil?
	@statistic = OutstandingWorkIndex.find_by_sql ["SELECT 		
	dai.Date_Authorised, 
	DATEDIFF('hh',rs.Date_Time_Booked_In,rs.Date_Time_Authorised) as HrsIn,
	dai.Registration_Number, 
	dai.Request_Row_ID, 
	dai.Specimen_Number, 
	rs.Authorised_By, 
	rs.Namespace, 
	rs.Set_Code, 
	rs.Date_Time_Authorised, 
	R.Date_Time_Received, 
	R.Location 
FROM 
	Date_Authorised_Index dai    
	INNER JOIN Result_Set rs ON (dai.Date_Authorised = rs.Date_Authorised
                             AND dai.Request_Row_ID = rs.Request_Row_ID)
	INNER JOIN Request R ON (dai.Request_Row_ID = r.Request_Row_ID)
	
WHERE 
	rs.Set_Code=? AND 
	DATEPART('mm',dai.Date_Authorised) =? and 
	DATEPART('yy',dai.Date_Authorised) =?", params[:set_code].upcase, params[:month].to_i, params[:year].to_i]

	Cache.put 'paststats:'+ params[:set_code].upcase, @statistic

else
	  @statistic = Cache.get 'paststats:'+ params[:set_code].upcase
end
	
	  @setcode= params[:set_code].upcase
   	
if @statistic.empty?  
  # No records return just do layout
else
   	@completed = @statistic.size
   	hours2 = @statistic.map(&:HrsIn)
   	@median = median(hours2)
    @mean = mean(hours2)
    @mean = (@mean*100).round/100.0 
    @pcttat = (@median/336)*100
    @pcttat = (@pcttat*100).round/100.0 
  	
  	respond_to do |format|
      format.html
      format.xml  { render :action => "statistic.xml.builder", :layout => false }
    end
end

end

def tatbyday

if (Cache.get 'tatbyday:'+ params[:set_code] + params[:month]).nil?
	@statistics = OutstandingWorkIndex.find_by_sql ["SELECT 
	dai.Date_Authorised
  , rs.Date_Booked_In
  , avg(DATEDIFF('hh',rs.Date_Time_Booked_In,rs.Date_Time_Authorised)) as HrsIn
  , count(dai.Date_Authorised) as numbers
  , rs.Set_Code
  , rs.Date_Time_Authorised
  , r.Date_Time_Received
FROM 
  	Date_Authorised_Index dai    
	INNER JOIN Result_Set rs ON (dai.Date_Authorised = rs.Date_Authorised
                         AND dai.Request_Row_ID = rs.Request_Row_ID)
	INNER JOIN Request R ON (dai.Request_Row_ID = r.Request_Row_ID)
WHERE
	rs.Set_Code=:set_code AND 
	DATEPART('mm',dai.Date_Authorised) =:month and 
	DATEPART('yy',dai.Date_Authorised) =:year 
group by 
	rs.Date_Booked_In", 
	{:set_code => params[:set_code].upcase, 
	:month => params[:month].to_i, 
	:year => params[:year].to_i}]

  Cache.put 'tatbyday:'+ params[:set_code] + params[:month] , @statistics

else
	  @statistics = Cache.get 'tatbyday:'+ params[:set_code] + params[:month]
end

	
if @statistics.empty?  	
 # Do nothing no results returned
else
  @count = 0
	@counts = 0
	delay = 0
	numbers = 0
	tat = Array.new
	  @statistics.each do |statistic|
			if !statistic.HrsIn.nil?
				@count = @count +1
				if !statistic.numbers.nil?
					@counts = @counts + statistic.numbers.to_f
				end		
				tat[@count] = statistic.HrsIn.to_f
			end
		end
		
		@median = median(tat)
    @mean = mean(tat)
    @mean = (@mean*100).round/100.0 
    
end
    @setcode= params[:set_code].upcase
  	
  	respond_to do |format|
      format.html
      format.xml  { render :action => "statistic.xml.builder", :layout => false }
    end

end

def outstandingsets

if (Cache.get 'outstandingsets:'+ params[:set_code].upcase).nil?
  
  @statistics = OutstandingWorkIndex.find_by_sql("SELECT 
	count(*) as outstandingno,
	owi.Discipline, 
	rs.Set_Code, 
	R.Specimen_Number , 
	DATEDIFF('hh',rs.Date_Time_Booked_In,current_timestamp) as HrsIn 
FROM 
	Request R,
	Outstanding_work_index owi 
	INNER JOIN Result_Set rs ON (owi.Request_Row_ID = rs.Request_Row_ID
 	AND owi.Request_Row_ID = R.Request_Row_ID)
WHERE 
	rs.Date_Time_Authorised Is Null  
group by 
	rs.Set_Code
order by 
	rs.Date_Time_Booked_In DESC")

  Cache.put 'outstandingsets:'+ params[:set_code].upcase, @statistics

  else
  	  @statistics = Cache.get 'outstandingsets:'+ params[:set_code].upcase
  end


	respond_to do |format|
    	format.html # statistics.html.erb
    	format.xml  { render :xml => @statistics }
  end
  
end


def index
  if (Cache.get 'index:').nil?
    @outstanding = OutstandingWorkIndex.group("Discipline").order("Discipline").count("Discipline") 
    Cache.put 'index:', @outstanding
  else
  	  @outstanding = Cache.get 'index:'
  end
  @outs = @outstanding.size
  respond_to do |format|
    format.html # index.html.erb
    format.xml  { render :xml => @outstanding }
  end
end

def historical

if (Cache.get 'historical:'+ params[:set_code].upcase).nil?	
	@statistic = OutstandingWorkIndex.find_by_sql ["SELECT 		
	DATEDIFF('hh',R.Date_Time_Received,rs.Date_Time_Authorised) as HrsIn,
	rs.Set_Code,
	rs.Date_Time_Authorised,
	R.Date_Time_Received
FROM   
	Request R
	INNER JOIN Result_Set rs ON (rs.Request_Row_ID = R.Request_Row_ID)
WHERE
	rs.Set_Code=? AND 
	DATEPART('mm',rs.Date_Authorised) =? and 
	DATEPART('yy',rs.Date_Authorised) =?", params[:set_code].upcase, params[:month].to_i, params[:year].to_i]

  Cache.put 'historical:'+ params[:set_code].upcase, @statistic

  else
  	  @statistic = Cache.get 'historical:'+ params[:set_code].upcase
  end
	
	@setcode= params[:set_code].upcase
   	@completed = @statistic.size
   	hours2 = @statistic.map(&:HrsIn)
   	@median = median(hours2)
    @mean = mean(hours2)
    @mean = (@mean*100).round/100.0 
    @pcttat = (@median/336)*100
    @pcttat = (@pcttat*100).round/100.0 
  	
  	respond_to do |format|
      format.html
      format.xml  { render :action => "historical.xml.builder", :layout => false }
    end

end



end
