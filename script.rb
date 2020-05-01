module Enumerable
  def my_each
    return enum_for unless block_given?

    change2arr = self.to_a if self.is_a?(Range)
    newArr = []
    for item in change2arr
      newArr << yield(item)
    end
    newArr
  end

  def my_each_with_index
    return enum_for unless block_given?

    for i in 0...self.length
      yield(self[i], i)  
    end
    self
  end

  def my_select
    return enum_for unless block_given?

    newArr = []
    for item in self
      newArr << item if yield(item)
    end
    newArr
  end

  def my_all?(arg=nil)
    my_each do |x|
      if !block_given?
        if arg
          if arg.is_a? Class
            if !x.is_a? arg
              return false
            end  
          elsif arg.is_a? Regexp
              if (x =~ arg).nil? 
                return false
              end
          else
            if !x == arg
              return false
            end
          end
        else
          if x.nil? or x == false
            return false
          end
        end
      else
        if !yield(x)
          return false
        end
      end
    end
    true
  end

  def my_any?(arg=nil)
    my_each do |x|
      if !block_given?
        if arg
          if arg.is_a? Class
            if x.is_a? arg
              return true
            end
          elsif arg.is_a? Regexp
            if !(x =~ arg).nil?
              return true
            end
          else
            if x == arg
              return true
            end
          end
        else
          if !x.nil? or x == false
            return true
          end
        end
      else
        if yield(x)
          return true
        end
      end
    end
    false
  end

  def my_none?(arg=nil)
    my_each do |x|
      if !block_given?
        if arg
          if arg.is_a? Class
            if x.is_a? arg
              return false
            end
          elsif arg.is_a? Regexp
            if !(x =~ arg).nil?
              return false
            end
          else
            if x == arg
              return false
            end
          end
        else
          if x 
            return false
          end
        end
      else
        if yield(x)
          return false
        end
      end
    end
    true
  end

  def my_count(arg=nil)
    working_array = self.is_a?(Range) ? to_a : self
    counter = 0
    if !block_given?
      if arg
        working_array.my_each do |x|
          if x == arg
            counter += 1
          end
        end
        return counter
      else
        return working_array.length
      end
    else
      working_array.my_each do |x|
        if yield(x)
          counter += 1
        end
      end
      return counter
    end
  end

  def my_map(proc=nil)
    return enum_for if !block_given?
    
    new_array = []
    each do |x|
      if proc
        new_array << proc.call(x)
      else
        new_array << yield(x)
      end
    end
    return new_array
  end

  def my_inject(init=nil, sym=nil)
    working_array = self.to_a
    if init and sym
      acc = init
      working_array.my_each do |x|
        acc = acc.send(sym, x)  
      end
      return acc
    elsif init and !block_given?
      sym = init
      acc = working_array[0]
      for i in 1...working_array.length
        acc = acc.send(sym, working_array[i])
      end
      return acc
    elsif init and block_given?
      acc = init
      working_array.my_each do |x|
        acc = yield(acc, x)
      end
      return acc
    else
        acc = working_array[0]
        for i in 1...working_array.length
        acc = yield(acc, working_array[i])
        end
        return acc
    end
  end

end

def multiply_els(arr)
    arr.my_inject(:*)
end

puts "TEST: my_each"
puts "expected result: #=> [5, 10, 15, 20, 25, 30, 35, 40, 45, 50]"
puts "ACTUAL RESULT:"
print (1..10).my_each { |i| i*5 } 
puts "\n "
puts "TEST: my_each_with_index"
puts "expected result: #=> {'cat'=>0, 'dog'=>1, 'wombat'=>2}"
puts "ACTUAL RESULT:" 
hash = Hash.new
%w(cat dog wombat).my_each_with_index { |item, index|
  hash[item] = index
}
puts hash
puts "\n"
puts "TEST: my_select"
puts "expected result: #=> [3, 6, 9]"
puts "ACTUAL RESULT:" 
print (1..10).my_select { |i|  i % 3 == 0 }   
puts " "
puts "expected result: #=> [2, 4]"
puts "ACTUAL RESULT:" 
print [1,2,3,4,5].my_select { |num|  num.even?  }   
puts " "
puts "expected result: #=> [:foo]"
puts "ACTUAL RESULT:" 
print [:foo, :bar].my_select { |x| x == :foo }
puts " "
puts "\n"
puts "TEST: my_all?"
puts "expected results: "
puts "#=> true"
puts "#=> false"
puts "#=> false"
puts "#=> true"
puts "#=> false"
puts "#=> true"
puts "ACTUAL RESULTS:" 
puts %w[ant bear cat].my_all? { |word| word.length >= 3 }
puts %w[ant bear cat].my_all? { |word| word.length >= 4 } 
puts %w[ant bear cat].my_all?(/t/)                        
puts [1, 2i, 3.14].my_all?(Numeric)                      
puts [99, true, nil].my_all?                              
puts [].my_all?                                         
puts "\n"
puts "TEST: my_any?"
puts "expected results: "
puts "#=> true"
puts "#=> true"
puts "#=> false"
puts "#=> true"
puts "#=> true"
puts "#=> false"
puts "ACTUAL RESULTS:" 
puts %w[ant bear cat].my_any? { |word| word.length >= 3 }
puts %w[ant bear cat].my_any? { |word| word.length >= 4 } 
puts %w[ant bear cat].my_any?(/d/)                        
puts [nil, true, 99].my_any?(Integer)                     
puts [nil, true, 99].my_any?                              
puts [].any?                                              
puts "\n"
puts "TEST: my_none?"
puts "expected results: "
puts "#=> true"
puts "#=> false"
puts "#=> true"
puts "#=> false"
puts "#=> true"
puts "#=> true"
puts "#=> true"
puts "#=> false"
puts "ACTUAL RESULTS:" 
puts %w{ant bear cat}.my_none? { |word| word.length == 5 }
puts %w{ant bear cat}.my_none? { |word| word.length >= 4 }
puts %w{ant bear cat}.my_none?(/d/)                        
puts [1, 3.14, 42].my_none?(Float)                         
puts [].my_none?                                           
puts [nil].my_none?                                        
puts [nil, false].my_none?                                 
puts [nil, false, true].my_none?                           
puts "\n"
puts "TEST: my_count:"
puts "expected results: "
puts "#=> 4"
puts "#=> 2"
puts "#=> 3"
puts "ACTUAL RESULTS:"
ary = [1, 2, 4, 2]
puts ary.my_count               
puts ary.my_count(2)            
puts ary.my_count{ |x| x%2==0 } 
puts "\n"
puts "TEST: my_map:"
puts "expected result: #=> [1, 4, 9, 16]"
puts "ACTUAL RESULT:"
print (1..4).my_map { |i| i*i }
puts " "
puts "expected result: #=> ['cat', 'cat', 'cat', 'cat']"
puts "ACTUAL RESULT:"
print (1..4).my_map { "cat"  }   
puts "\n "
puts "TEST: my_inject:"
puts "expected result:"
puts "#=> 45"
puts "#=> 45"
puts "#=> 151200"
puts "#=> 151200"
puts "#=> sheep"
puts "ACTUAL RESULT:"
puts (5..10).my_inject(:+)                             
puts (5..10).my_inject { |sum, n| sum + n }            
puts (5..10).my_inject(1, :*)                          
puts (5..10).my_inject(1) { |product, n| product * n } 
longest = %w{ cat sheep bear }.my_inject do |memo, word|
   memo.length > word.length ? memo : word
end
puts longest                                           
puts "\n"
puts "\n"
puts "TEST: multiply_els:"
puts "expected result: #=> 40"
puts "ACTUAL RESULT:"
puts multiply_els([2,4,5])
puts "\n"
puts "\n"
puts "------------END OF TESTING--------------"                         

