include Math
require 'matrix'

def main
	lr = 0.6; #learning rate

	data_array = [[0.4,-0.7],[2.0,1.0],[4.0,3.0],[5.0,4.0]] #x,y
	desired_outputs = [0.1,1,4,5] #expected_outputs
	data_names =  ['A','B','C','D']
	n = data_array[0].size

	sum_E_sq = 0.0
	
	
	##initial weights
	weights_V = Matrix[[0.1,0.4],[-0.2,0.2]]
	weights_W = Matrix[[0.2],[-0.5]];

	##transpose of weight matrices
	vT = weights_V.transpose
	wT = weights_W.transpose

	##loop through dataset
	data_array.each_with_index do |d,iCount|
		print "Data #{d}\n"

		#create matrix
		input_matrix = Matrix[d].transpose;
		p input_matrix

		##Output of Input layer
		oI = Array.new(d.size)
		##for each input	
		input_matrix.each_with_index do |iI,r,c|
			#p "iI #{r},#{c} -> #{iI}"
			oI[r] = l1Func(iI)
		end
		#p oI
		output_input = Matrix[oI].transpose
		p "Oi -> #{output_input}"

		print "vT -> #{vT}\n"
		##Input of Hidden Layer
		input_hidden = vT * output_input
		p "Ih -> #{input_hidden}"

		##Output of Hidden Layer
		oH = Array.new(n)
		input_hidden.each_with_index do |iH,r,c|
			p "iH -> #{iH}"
			p "sigmoid(iH) -> #{sigmoid(iH)}"
			oH[r] = sigmoid(iH)
		end
		output_hidden = Matrix[oH].transpose
		p "Oh -> #{output_hidden}"

		##Input of output layer W.transpose * Oh
		print "wT -> #{wT}\n"
		input_output = wT * output_hidden
		p "Io -> #{input_output}"

		##Output of the Output Layer
		oO = Array.new(input_output.row_count)
		input_output.each_with_index do |iO,r,c|
			oO[r] = sigmoid(iO)
		end
		output_output = Matrix[oO].transpose
		p "Oo -> #{output_output}"

		##calculate error
		error_2 = (desired_outputs[iCount] - output_output[0,0])**2
		p "E^2  #{error_2}"
		sum_E_sq = sum_E_sq + error_2

		##new W weights 
		##change in weight = lr * E * X where X -> Oh
		##E = d = (y_s - y_t) y_s (1 - y_s) where y_s -> system output and y_t -> desires output
		y_s = output_output[0,0]
		y_t = desired_outputs[iCount]
		d = (y_t - y_s) * (y_s) * (1 - y_s)
		p "d  #{d}"
		changeW = lr * d * output_hidden
		print "changeW -> #{changeW}\n"

		##calculate e before changing weights
		e = weights_W * d

		weights_W = weights_W + changeW
		print "newW -> #{weights_W}\n\n"

		##new V weights 
=begin
		change in weight = lr * X_1 where X_1 -> Oi * d*_transpose
		d* = [a * g * (1-g)],[b * h * (1-h)]
		e = W.d = [a,b]
		Oh = [g,h]
		E = d = (y_s - y_t) y_s (1 - y_s) where y_s -> system output and y_t -> desires output
=end		
		#e = weights_W * d
		#p "e->  #{e}"
		p "e->  #{e}"


		#a = e[0,0]
		#b = e[1,0]

		#g = output_hidden[0,0] 
		#h = output_hidden[1,0] 

		#d_sta = Matrix[[(a*g*(1-g))],[(b*h*(1-h))]]


		##Output of Hidden Layer
		dS = Array.new(n)
		e.each_with_index do |eI,r,c|
			g = output_hidden[r,c]
			dS[r] = eI*g*(1-g)
			#p "dS[r]->  #{dS[r]}"
		end
		#p "dStar -> #{dS}"
		d_star = Matrix[dS].transpose
		p "dStar -> #{d_star}"

		x_1 = output_input * d_star.transpose
		p "x1 -> #{x_1}"
		changeV = lr * x_1
		print "changeV -> #{changeV}\n"

		weights_V = weights_V + changeV
		print "newV -> #{weights_V}\n"
		
		exit

		errorRate = (1/(iCount+1)) * sum_E_sq 
		print "errorRate -> #{errorRate}\n\n"
	end
	print "finalV -> #{weights_V}\n"
	print "finalW -> #{weights_W}\n"
end

def l1Func(x)
	x1 = x# * 2
	return x1
end

def sigmoid(x)
	return 1.0 / ( 1.0 + exp( -x ) )
end

main