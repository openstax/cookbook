RSpec.describe Kitchen::Mixins::BlockErrorIf do
  class BlockErrorIfTestClass
    include Kitchen::Mixins::BlockErrorIf
    def some_method
      block_error_if(block_given?)
    end
  end

  it 'raises a RecipeError if a block is given' do
    expect{BlockErrorIfTestClass.new.some_method{}}.to raise_error(Kitchen::RecipeError,/some_method/)
  end
end
