include Math

def main
	k = 2 #num of clusters
	atr_size = 3;
	data = [[1,1,2],[2,1,1],[4,3,4],[5,4,5]]
	data_names =  ['A','B','C','D']
	distance = Array.new(data.size){Array.new(k)}
	groups = Array.new(data.size)
	group_c = Array.new(data.size)
	centroids = Array.new

	#get initial centroids, first k elements
	k.times do |i|
		centroids[i] = data[i]
	end
	puts "centroids -> #{centroids}"

	#for d in data
	#end

	#until groups stop changing
	loop do
		#get distances
		data.each_with_index do |d,d_count|
			print "Dataset #{d}\n"
			centroids.each_with_index do |c,c_count|
				puts "(#{d[0]} - #{c[0]}) + (#{d[1]} -#{c[1]}) "
				v = (d[0]-c[0])**2 + (d[1]-c[1])**2
				val = Math.sqrt(v.abs)
				print "#{c[0]},#{c[1]} -> #{v} -> #{val}\n"
				distance[d_count][c_count] = val
			end
			#smallest distance
			smallest = smallestPos(distance[d_count]);
			puts "smallest -> #{smallest}"
			group_c[d_count] = smallest
		end

		puts "distances -> #{distance}"
		puts "groups -> #{group_c} vs #{groups} "
		
		break if group_c == groups
		
		groups = group_c

		#determine new coordinates
		#loop through each group
		groups_sum = Array.new(k){Array.new(atr_size,0)}
		groups_count = Array.new(k,0)
		data.each_with_index do |d,d_count| 
			#groups_centroid_sum[]
			puts "#{d} -> Group #{groups[d_count]}" 
			d.size.times do |c| #loop number_of_attribute.times
				puts "#{groups_sum[groups[d_count]][c]} += #{d[c]}"
				groups_sum[groups[d_count]][c] += d[c]
			end
			groups_count[groups[d_count]] += 1;
		end

		#avg the sum
		new_centroids = Array.new(k){Array.new(k,0)}
		print "group_sum\n"
		groups_sum.each_with_index do |group_sum,gs_count| 
			puts "#{gs_count} -> #{group_sum}" 
			group_sum.each_with_index do |atr,atr_count|#each attribute sum
				puts "#{atr}/#{groups_count[gs_count]}"
				print atr.to_f/groups_count[gs_count]
				puts "\n"
				new_centroids[gs_count][atr_count] = atr/groups_count[gs_count]
			end
		end

		puts "groups_sum -> #{groups_sum}"
		puts "groups_count -> #{groups_count}"
		puts "new_centroids -> #{new_centroids}"

		centroids = new_centroids
	end

	#print result
	data_names.each_with_index { |e,i| puts "#{e} -> Group #{groups[i]+1}" }
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