xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'

xml.outstanding do
	@outstanding.each do |outstanding|
		xml.record do
			xml.Specimen_Number outstanding.Specimen_Number
			xml.Consultant outstanding.Consultant
			xml.Set_Code outstanding.Set_Code
			xml.Date_Time_Booked_In outstanding.Date_Time_Booked_In
		end
	end
end
