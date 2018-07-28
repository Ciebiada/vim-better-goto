require_relative '../better_goto.rb'

describe BetterGoto do
  let(:padded_buffer) { [''].concat(buffer) }
  subject { described_class.new.goto_definition(cursor, padded_buffer) }

  context 'when looking for a simple variable' do
    let(:cursor) { [2, 13] }
    let(:buffer) do
      [
        'const foo = 10',
        'console.log(foo)'
      ]
    end

    it { should eq([1, 6]) }
  end

  context 'when variable cannot be found' do
    let(:cursor) { [2, 13] }
    let(:buffer) do
      [
        'const foo = 10',
        'console.log(bar)'
      ]
    end

    it { should eq(cursor) }
  end

  context 'when variable is scoped' do
    let(:cursor) { [4, 15] }
    let(:buffer) do
      [
        'const foo = 10',
        'const bar = () => {',
        '  const foo = 5',
        '  console.log(foo)',
        '}'
      ]
    end

    it { should eq([3, 8]) }
  end

  context 'when variable is out of scope' do
    let(:cursor) { [3, 15] }
    let(:buffer) do
      [
        'const foo = 10',
        'const bar = () => {',
        '  console.log(foo)',
        '}'
      ]
    end

    it { should eq([1, 6]) }
  end

  context 'when variable is an argument of a function' do
    let(:cursor) { [2, 14] }
    let(:buffer) do
      [
        'function foo(bar, x) {',
        '  console.log(bar)',
        '}'
      ]
    end

    it { should eq([1, 13]) }
  end

  context 'when variable is an argument of an arrow function' do
    let(:cursor) { [2, 14] }
    let(:buffer) do
      [
        'const foo = (bar, x) =>',
        '  console.log(bar)',
        '}'
      ]
    end

    it { should eq([1, 13]) }
  end

  context 'when variable is a single argument of an arrow function' do
    let(:cursor) { [2, 14] }
    let(:buffer) do
      [
        'const foo = bar =>',
        '  console.log(bar)',
        '}'
      ]
    end

    it { should eq([1, 12]) }
  end
end
