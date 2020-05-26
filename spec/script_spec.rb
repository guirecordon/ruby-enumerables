require_relative '../script.rb'

describe Enumerable do
  let(:arraio) { [1, 2, 3, 4, 5] }
  let(:rangio) { (1..5) }
  let(:blocko) { |element| element }
  let(:hasho) { {} }
  let(:stringos) { %w[cat dog wombat] }
  let(:block1) { proc { |x| x.length >= 3 } }
  let(:block2) { proc { |x| x.length >= 4 } }
  let(:words) { %w[ant bear cat] }
  let(:hashproc) { proc { |item, index| hasho[item] = index } }

  describe '#my_each' do
    context 'when no block is passed' do
      it 'returns an enumerator range when called against a range' do
        expect(rangio.my_each.class).to eql(arraio.each.class)
      end

      it 'returns an Enumerator array when called against an array' do
        expect(arraio.my_each.class).to eql(arraio.each.class)
      end
    end

    context 'when a block is passed' do
      it 'calls the given block once for each element in self and returns the array itself' do
        expect(arraio.my_each { blocko }).to eql(arraio.each { blocko })
      end

      it 'calls the given block once for each element in self and returns the range itself' do
        expect(rangio.my_each { blocko }).to eql(rangio.each { blocko })
      end
    end
  end

  describe '#my_each_with_index' do
    context 'when no block is passed' do
      it 'returns an enumerator' do
        expect(arraio.my_each_with_index.class).to eql(arraio.each_with_index.class)
      end
    end

    context 'when a block is passed' do
      it 'calls the item and its index for each item in enum' do
        expect(stringos.my_each_with_index(&hashproc)).to eql(stringos.each_with_index(&hashproc))
      end
    end
  end

  describe '#my_select' do
    let(:proco) { proc { |num| num.even? } }

    context 'when no block is given' do
      it 'returns an Enumerator' do
        expect(arraio.my_select.class).to eql(arraio.select.class)
      end
    end

    context 'when a block is given' do
      it 'returns an array for all element for which the block returns a true value' do
        expect(arraio.my_select(&proco)).to eql([2, 4])
      end
    end
  end

  describe '#my_all?' do
    let(:number) { [1, 2i, 3.14] }

    context 'when block is given' do
      it 'returns true if the block never returns false or nil' do
        expect(words.my_all?(&block1)).to eql(true)
      end
      it 'returns true if the block never returns false or nil' do
        expect(words.my_all?(&block2)).to eql(false)
      end
    end

    context 'when no block is given, instead a pattern is supplied' do
      it 'returns true if pattern === element' do
        expect(words.my_all?(/t/)).to eql(false)
      end

      it 'returns true if a patter === element' do
        expect(number.my_all?(Numeric)).to eql(true)
      end
    end

    context 'when no pattern nor block is supplied' do
      it 'return true if none of the collection members are false or nil' do
        expect([nil, true, 99].my_all?).to eql(false)
      end

      it 'return true if none of the collection members are false or nil' do
        expect([].my_all?).to eql(true)
      end
    end
  end

  describe '#my_any?' do
    context 'when a block is passed' do
      it 'returns true if the block ever returns a value other than false or nil' do
        expect(words.my_any?(&block1)).to eql(true)
      end

      it 'returns true if the block ever returns a value other than false or nil' do
        expect(words.my_any?(&block2)).to eql(true)
      end
    end

    context 'when no block is passed' do
      it 'returns whether pattern === element for any collection member' do
        expect(words.my_any?(/d/)).to eql(false)
      end

      it 'returns whether pattern === element for any collection member' do
        expect([nil, true, 99].any?(Integer)).to eql(true)
      end

      it 'returns false for all elements are new' do
        expect([].any?).to eql(false)
      end
    end
  end

  describe '#my_none' do
    let(:block3) { proc { |word| word.length == 5 } }
    let(:chifres) { [1, 3.14, 42] }

    context 'when there is a block' do
      it 'returns true if the block never returns true for all elements' do
        expect(words.my_none?(&block3)).to eql(true)
      end

      it 'returns true if the block never returns true for all elements' do
        expect(words.my_none?(&block2)).to eql(false)
      end
    end

    context 'when a pattern is supplied' do
      it 'returns true whether pattern === element for none of the collection members' do
        expect(chifres.my_none?(Float)).to eql(false)
      end

      it 'returns true whether pattern === element for none of the collection members' do
        expect(words.my_none?(/d/)).to eql(true)
      end
    end

    context 'when there is no block nor pattern given' do
      it 'returns true only if none of the collection members is true' do
        expect([].my_none?).to eql(true)
      end

      it 'returns true only if none of the collection members is true' do
        expect([nil].my_none?).to eql(true)
      end

      it 'returns true only if none of the collection members is true' do
        expect([nil, false].my_none?).to eql(true)
      end

      it 'returns true only if none of the collection members is true' do
        expect([nil, false, true].my_none?).to eql(false)
      end
    end
  end

  describe '#my_count' do
    context 'when no block nor argument is given' do
      it 'returns the count of items in the collection' do
        expect(arraio.my_count).to eql(5)
      end
    end

    context 'when an argument is passed' do
      it 'returns how many times the argument is found in the collection' do
        expect(arraio.my_count(2)).to eql(1)
      end
    end

    context 'when a block is given' do
      it 'returns how many times the block returns true' do
        expect(arraio.my_count(&:even?)).to eql(2)
      end
    end
  end

  describe '#my_map' do
    context 'when no block is given' do
      it 'returns an enumerator' do
        expect(rangio.my_map.class).to eql(rangio.map.class)
      end
    end

    context 'when a block or a proc is passed' do
      it 'returns a new array with the results of running blocks once for every element in enum' do
        expect(rangio.my_map { |x| x * x }).to eql([1, 4, 9, 16, 25])
      end

      it 'returns a new array with the results of running blocks once for every element in enum' do
        expect((1..4).my_map { 'cat' }).to eql(%w[cat cat cat cat])
      end
    end
  end

  describe '#my_inject' do
    context 'if you specify a block' do
      it 'returns the accumulated value as a result of the block passed to each element in the collection' do
        expect((5..10).my_inject(1) { |product, n| product * n }).to eql(151_200)
      end

      it 'returns the accumulated value as a result of the block passed to each element in the collection' do
        expect(%w[cat sheep bear].my_inject { |memo, word| memo.length > word.length ? memo : word }).to eql('sheep')
      end

      it 'returns the accumulated value as a result of the block passed to each element in the collection' do
        expect((5..10).my_inject { |sum, n| sum + n }).to eql(45)
      end
    end

    context 'if you don\'t specify a block and pass only an operator instead' do
      it 'return the accumulated value of the operation applied to each element in the collection' do
        expect((5..10).my_inject(:+)).to eql(45)
      end

      it 'returns the accumulated value of the operation applied to each element in the collection' do
        expect((5..10).reduce(1, :*)).to eql(151_200)
      end
    end
  end
end

describe '#multiply_els' do
  it 'returns the total value of all elements multiplied' do
    expect(multiply_els(5..10)).to eql(151_200)
  end
end
