require 'rspec'
require_relative '../../src/aspects'

describe '.on(filter,transform)' do

  context 'parameter injection' do

    let(:example_class) do
      myClass = Class.new()
      myClass.send(:define_method,:do_this,proc{|p1,p2| p1 + '-' + p2})
      myClass.send(:define_method,:do_that,proc{|p2,ppp| p2 + ':' + ppp})
      myClass
    end

    it 'should inject simple parameter' do
      Aspects.on example_class do
        transform(where has_parameters(1, /p2/)) do
          inject(p2: 'bar')
        end
      end
      instance = example_class.new
      expect(instance.do_this("foo")).to eq("foo-bar")
      expect(instance.do_this("foo", "foo")).to eq("foo-bar")
      expect(instance.do_that("foo", "foo")).to eq("bar:foo")
    end

    it 'should inject proc parameter' do
      Aspects.on example_class do
        transform(where has_parameters(1, /p2/)) do
          inject(p2: proc{ |receiver, message, prev_arg|
                   "bar(#{message}->#{prev_arg})" })
        end
      end
      expect(example_class.new.do_this('foo','foo')).to eq("foo-bar(do_this->foo)")
    end

  end

  context 'method redirection' do
    let(:class_a) do
      a = Class.new
      a.send(:define_method,:greet,proc{|x| "Hello, "+x})
      a
    end

    let(:class_b) do
      b = Class.new
      b.send(:define_method,:greet,proc{|x| "Hey, "+x})
      b
    end

    it 'should redirect the method' do
      example_a = class_a
      example_b = class_b

      Aspects.on example_a do
        transform(where has_name(/greet/)) do
          redirect_to(example_b.new)
        end
      end

      expect(example_a.new().greet("Jude")).to eq("Hey, Jude")

    end

  end

  context 'logic injection' do

    let(:example_class)do
      myClass = Class.new()
      myClass.send(:attr_accessor,:x)
      myClass.send(:define_method,:m1,proc{|x,y| x+y+@x })
      myClass.send(:define_method,:m2,proc{|x| @x = x })
      myClass.send(:define_method,:m3,proc{|x| @x = x })
      myClass
    end

    it 'should inject, before, instead and after' do
    example = example_class
    Aspects.on example do
      transform(where has_name(/m1/)) do
        before do |x|
          @x = 15+x
        end
      end
      transform(where has_name(/m2/)) do
        after do
          if @x > 100
            2 * @x
          else
            @x
          end
        end
      end
      transform(where has_name(/m3/)) do
        instead_of do
          x*5
        end
      end
    end

    example_instance = example.new
    expect(example_instance.m1(1, 2)).to eq(19)
    expect(example_instance.x).to eq(16)

    expect(example_instance.m2(10)).to eq(10)
    expect(example_instance.m2(200)).to eq(400)

    example_instance.m3()
    expect(example_instance.x).to eq(200)
    end

  end

  context 'multiple transforms on a single origin' do
    let(:class_a) do
      a = Class.new
      a.send(:define_method,:greet,proc{|x| "Hello, "+x})
      a
    end

    let(:class_b) do
      b = Class.new
      b.send(:define_method,:greet,proc{|x| "Goodbye, "+x})
      b
    end

    it 'should apply multiple transforms' do
      example_a = class_a
      example_b = class_b

      Aspects.on example_b do
        transform(where has_name(/greet/)) do
        inject(x: "Sweet Charriot")
        redirect_to(example_a.new)
        end
      end

      expect(example_b.new.greet("World")).to eq("Hello, World")
    end
  end

end