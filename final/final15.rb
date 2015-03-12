def q15(num_array)
	result = []
	sum = 0
	num_array.each do |n|
		sum += n
		result.push(sum)
	end
	result
end

puts q15([1,2,3,4,5]).inspect