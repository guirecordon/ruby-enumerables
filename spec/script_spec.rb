require './script'

describe Enumerable do
  let(:arraio) { [1, 2, 3, 4, 5] }
  let(:rangio) { (1..5) }
  let(:blocko) { |element| element }
  let(:hasho) { {} }
  let(:stringos) { %w(cat dog wombat) }

  describe "#my_each" do
    context "when no block is passed" do
      it "returns an enumerator range when called against a range" do
        expect(rangio.my_each.class).to eql(arraio.each.class)    
      end

      it "returns an Enumerator array when called against an array" do
        expect(arraio.my_each.class).to eql(arraio.each.class)
      end
    end

    context "when a block is passed" do
      it "calls the given block once for each element in self and returns the array itself" do
        expect(arraio.my_each { blocko }).to eql(arraio.each { blocko } )
      end

      it "calls the given block once for each element in self and returns the range itself" do
        expect(rangio.my_each { blocko }).to eql(rangio.each { blocko } )
      end
    end
  end

  describe "#my_each_with_index" do
    context "when no block is passed" do
      it "returns an enumerator" do
        expect(arraio.my_each_with_index.class).to eql(arraio.each_with_index.class)
      end
    end

    context "when a block is passed" do
      it "calls the item and its index for each item in enum" do
        expect(stringos.my_each_with_index { |item, index| hasho[item] = index }).to eql(stringos.each_with_index { |item, index| hasho[item] = index })
      end
    end         
  end

  describe "#my_select" do
    let(:arraio) { [1, 2, 3, 4, 5] }
    let(:proco) { proc { |num| num.even? } }

    context "when no block is given" do
      it "returns an Enumerator" do
        expect(arraio.my_select.class).to eql(arraio.select.class)
      end
    end

    context "when a block is given" do
      it "returns an array for all element for which the block returns a true value" do
        expect(arraio.my_select { proco }).to eql(arraio.select { proco })
      end
    end
  end

  describe "#my_all?" do
    let(:word) { %w[ant bear cat] }
    let(:number) { [1, 2i, 3.14] }
    let(:block1) { proc { |x| x.length >= 3 }}
    let(:block2) { proc { |x| x.length >= 4 }}

    context "when block is given" do
      it "returns true if the block never returns false or nil" do
        expect(word.my_all? { block1 }).to eql(true)
      end
      it "returns true if the block never returns false or nil" do
        expect(word.my_all? { block2 }).to eql(word.all? { block2 })
      end
    end

    context "when no block is given, instead a pattern is supplied" do
      it "returns true if pattern === element" do
        expect(word.my_all?(/t/)).to eql(false)
      end

      it "returns true if a patter === element" do
        expect(number.my_all?(Numeric)).to eql(true)
      end
    end

    context "when no pattern nor block is supplied" do
      it "return true if none of the collection members are false or nil" do
        expect([nil, true, 99].my_all?).to eql(false)
      end

      it "return true if none of the collection members are false or nil" do
        expect([].my_all?).to eql(true)
      end

    end
  end

  describe "#my_any?" do
    let(:words) { %w[ant bear cat] }
    let(:block1) { proc { |word| word.length >= 3 } }
    let(:block2) { proc { |word| word.length >= 4 } }

    context "when a block is passed" do
      it "returns true if the block ever returns a value other than false or nil" do
        expect(words.my_any? { block1 }).to eql(true)
      end

      it "returns true if the block ever returns a value other than false or nil" do
        expect(words.my_any? { block2 }).to eql(true)
      end

      it "returns whether pattern === element for any collection member" do
        expect(words.my_any?(/d/)).to eql(false)
      end

      it "returns whether pattern === element for any collection member" do
        expect([nil, true, 99].any?(Integer)).to eql(true)
      end

      it "returns false for all elements are new" do
        expect([].any?).to eql(false)
      end


    end
  end
end