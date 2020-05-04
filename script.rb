module Enumerable
  def my_each
    return enum_for unless block_given?

    for item in self
      yield(item)
    end
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    for i in 0...length
      yield(self[i], i)
    end
  end

  def my_select
    return enum_for unless block_given?

    new_arr = []
    for item in self
      new_arr << item if yield(item)
    end
    new_arr
  end

  def my_all?(arg = nil)
    my_each do |x|
      if !block_given?
        case arg
        when Class
          return false unless x.is_a? arg
        when Regexp
          return false unless (x =~ arg).nil?
        else
          return false unless x.nil? or x == false
        end
      else
        return false unless yield(x)
      end
    end
    true
  end

  def my_any?(arg = nil)
    my_each do |x|
      if !block_given?
        case arg
        when Class
          return true if x.is_a? arg
        when Regexp
          return true unless (x =~ arg).nil?
        else
          return true unless x.nil? or x != false
        end
      else
        return true if yield(x)
      end
    end
    false
  end

  def my_none?(arg = nil)
    my_each do |x|
      if !block_given?
        case arg
        when Class
          return false if x.is_a? arg
        when Regexp
          return false unless (x =~ arg).nil?
        else
          return false if x
        end
      else
        return false if yield(x)
      end
    end
    true
  end

  def my_count(arg = nil)
    counter = 0
    if !block_given?
      return length unless arg

      (my_each { |x| counter += 1 if x == arg }) if arg
    else
      my_each { |x| counter += 1 if yield(x) }
    end
    counter
  end

  def my_map(proc = nil)
    return enum_for unless block_given?

    new_array = []
    if proc
      my_each { |x| new_array << proc.call(x) }
    else
      my_each { |x| new_array << yield(x) }
    end
    new_array
  end

  def my_inject(init = nil, sym = nil)
    list = self
    working_array = list.to_a
    if init and sym
      acc = init
      working_array.my_each { |x| acc = acc.send(sym, x) }
    elsif init and !block_given?
      sym = init
      acc = working_array[0]
      for i in 1...working_array.length
        acc = acc.send(sym, working_array[i])
      end
    elsif init and block_given?
      acc = init
      working_array.my_each { |x| acc = yield(acc, x) }
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
