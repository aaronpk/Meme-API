class MemeMatch

  def self.split(input)
    top = nil
    bottom = nil

    split = input.split '|'

    if split.length == 1
      if input[-1] == "|"
        top = split[0]
      else
        bottom = split[0]
      end
    elsif split.length == 2
      top = split[0]
      bottom = split[1]
    end

    top = top.gsub(/[. \|]+$/,'') if top
    bottom = bottom.gsub(/[. \|]+$/,'').gsub(/^[| ]+/,'') if bottom

    top = nil if top == ""
    bottom = nil if bottom == ""

    {
      top: top,
      bottom: bottom
    }
  end

  @@memes = {}

  def self.load_memes
    @@memes = JSON.parse IO.read File.dirname(__FILE__) + '/../memes.json'
  end

  def self.memes
    @@memes['memes']
  end

  def self.match_meme(input)
    self.memes.each do |meme|
      if match=Regexp.new(meme['regex'], true).match(input)
        return {
          top: match.captures[0],
          bottom: match.captures[1],
          img: meme['img']
        }
      end
    end
    nil
  end

end
