xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'

xml.outstanding do
	@outstanding.each do |outstanding|
		xml.record do
			xml.Discipline outstanding.Discipline
			xml.Registration outstanding.Registration_Number
		end
	end
end
