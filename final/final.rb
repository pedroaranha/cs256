def strange_sum
	sum = 0
	0.upto(5000) do |i|
		if (i % 3 > 0) && (i % 5 > 0) && (i % 7 > 0)
			sum += i;
		end
	end
	sum
end

puts strange_sum