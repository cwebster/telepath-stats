xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'

xml.chart do
    # xml.message "You can broadcast any message to chart from data XML file", :bg_color => "#FFFFFF", :text_color => "#000000"
    xml.series do    
    	@statistic.each_with_index do |statistic, index|
        xml.value statistic.Specimen_Number,   :xid => index
      end
    end
     
xml.graphs do
     #the gid is used in the settings file to set different settings just for this graph
      xml.graph :gid => 'stats' do
        @statistic.each_with_index do |statistic, index|
          hours = statistic.HrsIn
          
          if !hours.nil?
          	if hours > 330
               xml.value hours,   :xid => index, :color => "#ff43a8", :gradient_fill_colors => "#960040,#ff43a8", :description => statistic.Specimen_Number
            else
				xml.value hours,  :xid => index, :color => "#00C3C6", :gradient_fill_colors => "#009c9d,#00C3C6", :description => statistic.Specimen_Number

            end
          end
          
       
        end
      end
    end

  end
