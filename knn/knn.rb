include Math

k = 3
data = [[7,7,0],[7,4,0],[3,4,1],[1,4,1]]
query = [3,7]
distance = Array.new

for d in data
	#print "#{d[0]}\n"
	v = (d[0]-query[0])^2 + (d[1]-query[1])^2
	val = Math.sqrt(v.abs)
	print "#{v}\n"
end