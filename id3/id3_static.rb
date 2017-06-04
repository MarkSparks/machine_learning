include Math
=begin

	MODEL | Engine | Turbo | Weight | Fuel Eco | Fast
	__________________________________________________
	prius | small  | no    | average| good     | no
	civic | small  | no    | light  | average  | no 
	WRX   | small  | yes   | average| bad      | yes	

	Engine: small => 0; medium => 1; large => 2
	Turbo: no => 0; yes => 1
	Weight: average => 0; light => 1; heavy => 2
	Fuel: good => 0; average => 1; bad => 2
	Fast: no => 0; yes => 1

=end

def main
	##Target classification ->  Fast
	target = 5
	attr_num = 5
	data = [[0,0,0,0,0],[0,0,1,1,0],[0,1,0,2,1],[1,0,2,2,1],[2,0,1,2,1],
			[1,0,1,2,0],[2,1,2,2,0],[2,0,2,2,0],[1,1,1,2,1],[2,0,0,2,1],
			[0,0,1,0,0],[0,0,0,1,0],[1,0,2,2,0],[0,1,0,1,0],[1,0,2,2,0]
		  ];
	data_names = ['Prius','Civic','WRX','M3','RS4',
				'GTI','XJR','S500','911','Corvette',
				'Insight','RSX','IS350','MR2','E320']

	iD3(data,target,attr_num)
end

def iD3(data,target,attr_num)
	#info entropy for system based on the target attr
	iE_system = systemEntropy(data,target)

	#find information gain for values of all attributes
	infoGain = Array.new(attr_num)
	attr_num.times do |a|
		print "a-> #{a}\n"
		#at attribute c e.g. Engine
		if(a != (target-1))
			#a_pos = a - 1
			##loop through all possible attributes
			##get all possible attributes
			attr_count = Array.new(data.size,0)
			data.each do |d|
				attr_count[d[a]] = attr_count[d[a]] + 1
			end
			attr_count.delete_if{|a| a == 0 }##if zero is between figures??
			#print "Attr Count -> #{attr_count}\n"

			#end recursion
			if(attr_count.size <= 1)
				return
			end

			##get ie for all attributes 
			sum = 0.0
			size = data.size
			attr_count.each_with_index do |aC,i|
				##each attr e.g. small engine
				print "attr_Count -> #{aC}\n"
				iE_attr = infoEntropy(data,target,a,i)
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

	##remove attribute to get new dataset
	new_data = data.transpose
	new_data.delete_at(greatest)
	new_data =	new_data.transpose
	print "#{new_data}\n"

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
	print "Entropy -> #{entropy}\n"

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
			print "d-> #{d}\n"
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