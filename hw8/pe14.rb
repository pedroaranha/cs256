def collatz(n)
  val = n

  if val <= 1
    return val
  end
 
  len = 1

  while val != 1

    if val % 2 == 0
      val /= 2
    else
      val = (3 * val) + 1       
    end

    len += 1     
  end
   
  len
end

def longest_collatz(n)
	start = n
	longest = 0

	1.upto(n) do |num|  
		collatz = collatz(num)

		if collatz > longest
			start = num
			longest = collatz
		end

	end

  [longest,start]
end

load('runner.rb')