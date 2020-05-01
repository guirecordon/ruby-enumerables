module Enumerable
  def my_each
    return enum_for unless block_given?
    change2arr = self.is_a?(Range) ? to_a : self
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