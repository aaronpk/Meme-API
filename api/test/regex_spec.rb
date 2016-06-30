require_relative './init'

describe MemeMatch do

  def assert_top_and_bottom(match)
    match[:top].must_equal 'top'
    match[:bottom].must_equal 'bottom'
  end

  def assert_bottom_only(match)
    match[:top].must_equal nil
    match[:bottom].must_equal 'bottom'
  end

  def assert_top_only(match)
    match[:top].must_equal 'top'
    match[:bottom].must_equal nil
  end

  it 'matches top and bottom' do
    assert_top_and_bottom MemeMatch.split('top... | bottom.')
    assert_top_and_bottom MemeMatch.split('top... | bottom')
    assert_top_and_bottom MemeMatch.split('top. | bottom.')
    assert_top_and_bottom MemeMatch.split('top. | bottom')
    assert_top_and_bottom MemeMatch.split('top | bottom.')
    assert_top_and_bottom MemeMatch.split('top | bottom')
  end

  it 'matches bottom' do
    assert_bottom_only MemeMatch.split('bottom')
    assert_bottom_only MemeMatch.split('bottom.')
    assert_bottom_only MemeMatch.split('|bottom')
    assert_bottom_only MemeMatch.split('| bottom')
  end

  it 'matches top' do
    assert_top_only MemeMatch.split('top|')
    assert_top_only MemeMatch.split('top |')
    assert_top_only MemeMatch.split('top. |')
  end

  it 'matches full sentence' do
    match = MemeMatch.split('line one. with a period. | line two.')
    match[:top].must_equal 'line one. with a period'
    match[:bottom].must_equal 'line two'
  end

  MemeMatch.load_memes
  MemeMatch.memes.each do |meme|
    it "matches #{meme['img']}" do
      result = MemeMatch.match_meme meme['test']
      result.wont_be_nil
      result[:img].must_equal meme['img']
    end
  end

end
