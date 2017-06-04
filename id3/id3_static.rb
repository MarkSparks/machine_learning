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
	data = [[0,0,0,0,0],[0,0,1,1,0],[0,1,1,2,1],[1,0,2,2,1],[2,0,0,2,1],
			[1,0,1,2,0],[2,1,2,2,0],[2,0,0,2,1],[1,1,2,2,1],[2,0,0,2,1],
			[1,0,0,0,0],
			[1,0,1,1,0],
			[0,0,1,2,1],
			[1,1,2,2,1],
			[2,0,0,2,1]
		  ];
	data_names = ['Prius','Civic','WRX','M3','RS4',
				'GTI','XJR','S500','911','Corvette',
				'Insight','RSX','IS350','MR2','E320']

	#info entropy for system based on the target attr
	iE_system = systemEntropy(data,target)

	#find entropy for values of all other attributes
	attr_num.times do |a|
		print "a-> #{a}\n"
		#at attribute c e.g. Engine
		if(a != (target-1))
			#a_pos = a -1	
			##loop through all possible attributes
			##get all possible attributes
			attr_count = Array.new(data.size,0)
			data.each do |d|
				attr_count[d[a]] = attr_count[d[a]] + 1
			end
			attr_count.delete_if{|a| a == 0 }##if zero is between figures??
			#print "Attr Count -> #{attr_count}\n"

			##get ie for all attributes 
			sum = 0
			size = data.size
			attr_count.each_with_index do |aC,i|
				##each attr e.g. small engine
				print "attr_Count -> #{aC}\n"
				iE_attr = infoEntropy(data,target,a,i)

				sum = sum + ((aC/size)*iE_attr)
			end

			infoGain = iE_system - sum

			print "info Gain for attr #{a} -> #{infoGain}\n\n"

		end
	end 

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