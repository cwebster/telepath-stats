class StatsController < ApplicationController

	def patient_means
		
		if (Cache.get 'patmeans:' + params[:start_date] + params[:set_code].upcase).nil?
		
		@patient_means = DateAuthorisedIndex.find_by_sql ["
			SELECT 
				AVG(Result) as PatMean, count(Result) as numbers,
				iLabTP.Date_Authorised_Index.Date_Authorised 
			FROM 
				iLabTP.Test_Result, 
				iLabTP.Date_Authorised_Index, 
				iLabTP.Result_Set
			Where
				(iLabTP.Date_Authorised_Index.Date_Authorised between ? and ?)
				and iLabTP.Date_Authorised_Index.namespace in ('CHEMHRT')
				and iLabTP.Date_Authorised_Index.Request_Row_ID=iLabTP.Result_Set.Request_Row_ID
				and iLabTP.Result_Set.Result_Set_Row_ID = Test_Result.Result_Set_Row_ID
				and Test_Result.Test_Code = ?
			GROUP BY
				iLabTP.Date_Authorised_Index.Date_Authorised", params[:start_date], 			 params[:end_date],params[:set_code].upcase]
		
			Cache.put 'patmeans:'+ params[:start_date] + params[:set_code].upcase, @patient_means
		else
    		@patient_means = Cache.get 'patmeans:' + params[:start_date] + params[:set_code].upcase
    		
		end
	
	count = 0
	numbers = 0
	numb = Array.new
	
	@patient_means.each do |statistic|
		if !statistic.PatMean.nil?
			count = count +1
			numbers = numbers + statistic.numbers.to_f		
			numb[count] = statistic.numbers.to_f
    	end  

	end
	
	@setcode = params[:set_code]
	
	respond_to do |format|
      	format.html # patient_means.html.erb

    end
	end
end
	