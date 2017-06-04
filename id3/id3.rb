include Math
=begin
	***Diabetes Data***/
	NUMBER OF ATTRIBUTES: 
	8 
	  A1. Number of times pregnant
	  A2. Plasma glucose concentration a 2 hours in an oral
	         glucose tolerance test
	  A3. Diastolic blood pressure (mm Hg)
	  A4. Triceps skin fold thickness (mm)
	  A5. 2-Hour serum insulin (mu U/ml)
	  A6. Body mass index (weight in kg/(height in m)^2)
	  A7. Diabetes pedigree function
	  A8. Age (years)
	Brief statistical analysis: 
	   Attribute number:    Mean:   Standard Deviation:
	   A1.                     3.8     3.4
	   A2.                   120.9    32.0
	   A3.                    69.1    19.4
	   A4.                    20.5    16.0
	   A5.                    79.8   115.2
	   A6.                    32.0     7.9
	   A7.                     0.5     0.3
	   A8.                    33.2    11.8

=end

def main
	data = Array.new
	##read data from file
	counter = 0
	file = File.new("pimadiabetes.data.txt", "r")
	while (line = file.gets)
	    if((line.count "0-9") > 0)
	    	attributes = line.gsub(/\s+/m, ' ').strip.split(" ").map { |s| s.to_f }
	    	#print "#{attributes} \n"
	    	data[counter] = attributes
	    	counter = counter + 1
	    end
	end

	file.close

	n = data[0].size
	#p n
	##Target classification 
	attr_num = data[0].size
	target = attr_num #last attribute

	#p data

	#exit

	iD3(data,target,attr_num)
end

def iD3(data,target,attr_num)
	#end recursion
	if(attr_num <= 1)
		p "iD3 complete"
		return
	end
	#info entropy for system based on the target attr
	iE_system = systemEntropy(data,target)

	no_var = Array.new(attr_num-1){Array.new()}
	#find information gain for values of all attributes
	infoGain = Array.new(attr_num)
	attr_num.times do |a|
		print "a-> #{a}\n"
		#at attribute c e.g. Engine
		if(a != (target-1))
			#a_pos = a - 1
			##loop through all possible attributes
			##get all possible attributes
			attr_count = Array.new(data.size+1,0)
			print "Data size -> #{attr_count.size}"
			#exit
			data.each_with_index do |d,i|
				if(attr_count[d[a]] == nil)
					#print "attr_count[d[a]] -> #{attr_count[d[a]]}\n"
					attr_count[d[a]] = 0
				end
				attr_count[d[a]] = attr_count[d[a]] + 1
			end
			attr_count.delete_if{|a| a == 0 }##if zero is between figures??
			#print "Attr Count -> #{attr_count}\n"

			##get ie for all attributes 
			sum = 0.0
			size = data.size
			attr_count.each_with_index do |aC,i|
				##each attr e.g. small engine
				print "attr_Count -> #{aC}\n"
				iE_attr = infoEntropy(data,target,a,i)

				##mark attributes that have no variability
				if(iE_attr == 0)
					no_var[a] << i
				end

				sum = sum + ((aC.to_f/size.to_f)*iE_attr.to_f)
			end
			print "Sum -> #{sum}\n"
			infoGain[a] = iE_system - sum


			print "info Gain for attr #{a} -> #{infoGain[a]}\n\n"

		end
	end 
	print "info Gains -> #{infoGain}\n"
	##find greatest information gain
	greatest = 0;#TODO: if the target attribute is at pos 0  
	infoGain.each_with_index do |iG, attr_pos|
		#p iG
		if(iG != nil && iG > infoGain[greatest])
			greatest = attr_pos
		end
	end

	print "Attr #{greatest+1} has the greatest IG\n"

	##remove fields with no variability in greatest
	print "Data -> #{data}\n"
	print "no_var -> #{no_var[greatest]}\n"
	##remove values where attr greatest is either of the vales in no var
	no_var[greatest].each do |nvVal|
		#print "nvVal ->  #{nvVal}\n"
		data.each_with_index do |d,i|
			#print "d -> #{d} where val at #{greatest} == #{nvVal} \n"
			if(d[greatest] == nvVal)
				data.delete_at(i)
			end
		end
	end

	##remove attribute to get new dataset
	new_data = data.transpose
	new_data.delete_at(greatest)
	new_data =	new_data.transpose
	print "New Data -> #{new_data}\n\n\n"

	iD3(new_data,target-1,attr_num-1)

end

def systemEntropy(data,attr_pos)
	attr_pos -= 1
	s = data.size
	##find all variants of target attr
	a_count = Array.new(s,0)

	data.each { |d|
		#p d[attr_pos]
		a_count[d[attr_pos]] = a_count[d[attr_pos]] + 1
	}
	a_count.delete_if{|a| a == 0 }
	#print "Attr count -> #{a_count}\n"

	entropy = 0.0
	a_count.each do |aC|
		#print "#{aC} / #{s} = #{aC.to_f/s}\n"
		entropy = entropy - ((aC.to_f/s.to_f) * log(aC.to_f/s.to_f,2))
	end
	#noEmptyCities = cities.reject { |c| c.empty? }
	print "System Entropy -> #{entropy}\n"

 	return entropy
end
def infoEntropy(data,target_attr,attr_pos,attr_value)
	#attr_pos -= 1
	target_attr -= 1
	s = 0
	##find all variants of target attr
	a_count = Array.new(data.size,0)

	data.each { |d|
		if(d[attr_pos] == attr_value)
			#print "d-> #{d}\n"
			a_count[d[target_attr]] = a_count[d[target_attr]] + 1
			##increse size of sub dataset
			s = s + 1
		end
	}
	a_count.delete_if{|a| a == 0 }
	print "Target attr count -> #{a_count} of #{s}\n"

	entropy = 0.0
	a_count.each do |aC|
		#print "#{aC} / #{s} = #{aC.to_f/s}\n"
		entropy = entropy - ((aC.to_f/s.to_f) * log(aC.to_f/s.to_f,2))
	end
	#noEmptyCities = cities.reject { |c| c.empty? }
	print "Entropy -> #{entropy}\n"

 	return entropy
end

main