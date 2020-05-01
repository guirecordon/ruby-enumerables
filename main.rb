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

end

puts "TEST: my_each"
puts "expected result: #=> [5, 10, 15, 20, 25, 30, 35, 40, 45, 50]"
puts "RESULT:"
print (1..10).my_each { |i| i*5 } 
puts "\n "