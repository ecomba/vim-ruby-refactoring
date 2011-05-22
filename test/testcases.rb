# rename local variable <leader>rrlv
def method
  asdf = 10
end

# rename instance variable <leader>rriv
class Foo
  def method_one
    @bar = foo
  end

  def method_two
    @bar = bar
  end
end

# extract method <leader>rem
class Foo
  def method_one
    @bar = foo
  end

  def method_two
    one = 1
    two = 2
    three = 3
    four = two + two
    five = two + three
    six = five + one
  end
end
