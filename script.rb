module Enumerable
  def my_each
    return enum_for unless block_given?

    change2arr = self.to_a
    for item in change2arr
      yield(item)
    end
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

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
    my_each do |x|
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
    elsif init and !block_given?
      sym = init
      acc = working_array[0]
      for i in 1...working_array.length
        acc = acc.send(sym, working_array[i])
      end
    elsif init and block_given?
      acc = init
      working_array.my_each do |x|
        acc = yield(acc, x)
      end
    else
        acc = working_array[0]
        for i in 1...working_array.length
        acc = yield(acc, working_array[i])
        end
    end
    acc
  end

end

def multiply_els(arr)
    arr.my_inject(:*)
end

p [1,2,3,4].my_each

