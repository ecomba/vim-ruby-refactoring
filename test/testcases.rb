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
