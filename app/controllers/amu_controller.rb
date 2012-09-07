class AmuController < ApplicationController
  def outstanding

  @outstanding = OutstandingWorkIndex.find_by_sql("SELECT
    	dri.Specimen_Number,dri.Namespace,r.Consultant,r.Location,
    	p.Registration_Number,rs.Set_Code,rs.Record_State, rs.Date_Time_Booked_In
    FROM
    	iLabTP.Date_Received_Index dri,iLabTP.Request r,iLabTP.Patient p,iLabTP.Result_Set rs
    WHERE 
    	datediff('dd',dri.Date_received,dateadd(dd,-1,Current_date)) < 7 AND
    	dri.Request_Row_ID =r.Request_Row_ID AND
    	r.Patient_Row_ID = p.patient_row_id AND
    	r.Location in ('AMU1','AMU2') AND
    	dri.Request_Row_ID = rs.Request_Row_ID AND
    	rs.Record_State not like 'A%'")

  	respond_to do |format|
      	format.html # outstanding.html.erb
      	format.json { render :file => "outstanding.json.erb", :content_type => 'application/json'}
      	format.xml  { render :xml => @outstanding }
      	format.js  { render :json => @outstanding }
    end

  end
  
  
end