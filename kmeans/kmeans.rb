include Math

def main
	##read data from file
	counter = 0
	data = Array.new
	file = File.new("pimadiabetes.data.txt", "r")
	while (line = file.gets)
	    	#puts "#{counter}: #{line} \n"
	    	#print "line length -> #{line.delete("\n").delete(" ").length} \n"
	    	#print "line nums -> #{line.count "0-9"} \n"
	    	#print "line -> #{line}"
	    if((line.count "0-9") > 0)
	    	attributes = line.gsub(/\s+/m, ' ').strip.split(" ").map { |s| s.to_i }
	    	##last value in dataset is not an attribute
	    	attributes.pop
	    	#print "#{attributes} \n"
	    	data[counter] = attributes
	    	counter = counter + 1
	    end
	end

	#print "count => #{attributes.length} \n"
	#print "data => #{data}"
	file.close

	#exit

	k = 2 ##num of clusters
	atr_size = attributes.length;

	distance = Array.new(data.size){Array.new(k)}
	groups = Array.new(data.size)
	group_c = Array.new(data.size)
	centroids = Array.new

	##get initial centroids, first k elements
	k.times do |i|
		centroids[i] = data[i]
	end
	#puts "centroids -> #{centroids}"

	#for d in data
	#end

	##until groups stop changing
	loop do
		#get distances
		data.each_with_index do |d,d_count|
			#print "Dataset #{d}\n"
			centroids.each_with_index do |c,c_count|
				#puts "(#{d[0]} - #{c[0]}) + (#{d[1]} -#{c[1]}) "
				
				##calculate distance
				###get sum
				sum = 0
				d.each_with_index do |attr_value, attr_index|
					sum = sum + (attr_value - c[attr_index])**2
				end
				###Calculate sqrt
				val = Math.sqrt(sum.abs)
				#print "#{c[0]},#{c[1]} -> #{v} -> #{val}\n"
				###save distance
				distance[d_count][c_count] = val
			end
			##smallest distance
			smallest = smallestPos(distance[d_count]);
			##puts "smallest -> #{smallest}"
			group_c[d_count] = smallest
		end

		#puts "distances -> #{distance}"
		#puts "groups -> #{group_c} vs #{groups} "
		
		break if group_c == groups
		
		groups = group_c

		##determine new coordinates
		##loop through each group
		groups_sum = Array.new(k){Array.new(atr_size,0)}
		groups_count = Array.new(k,0)
		data.each_with_index do |d,d_count| 
			#puts "#{d} -> Group #{groups[d_count]}" 
			##loop number_of_attribute.times
			d.size.times do |c| 
				groups_sum[groups[d_count]][c] += d[c]
			end
			groups_count[groups[d_count]] += 1;
		end

		##avg the sum
		new_centroids = Array.new(k){Array.new(k,0)}
		#print "group_sum\n"
		groups_sum.each_with_index do |group_sum,gs_count| 
			#puts "#{gs_count} -> #{group_sum}" 
			group_sum.each_with_index do |atr,atr_count|#each attribute sum
				#puts "#{atr}/#{groups_count[gs_count]}"
				#print atr.to_f/groups_count[gs_count]
				#puts "\n"
				new_centroids[gs_count][atr_count] = atr/groups_count[gs_count]
			end
		end

		puts "groups_count -> #{groups_count}"
=begin
		puts "groups_sum -> #{groups_sum}"
		puts "new_centroids -> #{new_centroids}"
=end
		centroids = new_centroids
	end

	##print result
	if defined? data_names
		data_names.each_with_index { |e,i| puts "#{e} -> Group #{groups[i]+1}" }
	else
		groups.each_with_index { |group,i| print "#{i+1} -> Group #{group};" }
	end
		
end


def smallestPos(a)
	s = 0
	a.each_with_index do |dis,dis_count|
		if dis < a[s]
			s = dis_count
		end
	end
	return s
end

main