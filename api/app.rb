require_relative './lib/meme-match'
require 'json'

MemeMatch.load_memes
$config = YAML.load_file 'config.yml'

get '/g' do

  if !params[:u].match(/^http:/)
    return "Invalid image url"
  end

  open(params[:u], 'rb') do |f|
    begin
      i = MemeCaptain.meme_top_bottom(f, params[:t1], params[:t2], :font => './Impact.ttf')
      if(params[:u].match(/\.gif$/))
        ext = "gif"
      else 
        ext = "jpg"
      end
      filename = "#{DateTime.now.to_sxg}#{SecureRandom.random_number(60**5).to_sxg}.#{ext}"
      i.write("./public/m/#{filename}")
      headers 'Content-type' => 'application/json'
      {imageUrl: "http://#{request.host}/#{filename}"}.to_json
    rescue => e
      {error: e.message}
    end
  end

end

post '/message' do

  # TikTokBot posts JSON
  request.body.rewind
  @params = JSON.parse request.body.read

  top = nil
  bottom = nil
  img = nil

  if match=/^!meme (.+)/.match(@params['content'])
    # user explicitly requested a meme
    text = match.captures[0]
    # check if they specified an image or image search
    if match=/\[(https?:\/\/[^\] ]+)\]$/.match(text)
      text = match.captures[0]
      img = match.captures[1]
      split = MemeMatch.split text
      top = split[:top]
      bottom = split[:bottom]
    elsif match=/(.+) \[([^\]]+)\]$/.match(text)
      text = match.captures[0]
      search = match.captures[1]
      split = MemeMatch.split text
      top = split[:top]
      bottom = split[:bottom]
      img = image_search search
    else
      # check if the meme matches a pattern
      if match=MemeMatch.match_meme(text)
        top = match[:top]
        bottom = match[:bottom]
        img = match[:img]
      else
        # If it doesn't, make a meme anyway because it was explicitly requested
        split = MemeMatch.split text
        top = split[:top]
        bottom = split[:bottom]
        img = "aliens.jpg" # default
      end
    end
  else
    # all other chat messages are sent here, check if the line matches a meme pattern
    if match=MemeMatch.match_meme(@params['content'])
      top = match[:top]
      bottom = match[:bottom]
      img = match[:img]
    end
  end

  if img && !img.match(/^https?:\/\//)
    img = "./public/img/#{img}"
  end

  headers 'Content-type' => 'application/json'
  if img
    meme = make_meme img, top, bottom

    # If the message is from Slack, respond with the image as an attachment
    if @params['network'] == 'slack'
      if !top.nil? && !bottom.nil?
        title = "#{top} #{bottom}"
      elsif !top.nil?
        title = top
      else 
        title = bottom
      end

      response = {
        attachments: [
          {
            "fallback": meme[:url],
            "title": title,
            "image_url": meme[:url]
          }
        ]
      }.to_json
      response = {
        file: {
          "title": title,
          "filename": title,
          "url": meme[:url]
        }
      }.to_json
      puts response
      response
    else
      # otherwise respond with a link to the image
      {content: meme[:url]}.to_json
    end
  else
    {error: "no image"}.to_json
  end
end

def make_meme(img, top, bottom)
  open(img, 'rb') do |f|
    begin
      i = MemeCaptain.meme_top_bottom(f, top, bottom, :font => './Impact.ttf')
      if(img.match(/\.gif$/))
        ext = "gif"
      else 
        ext = "jpg"
      end
      filename = "#{DateTime.now.to_sxg}#{SecureRandom.random_number(60**5).to_sxg}.#{ext}"
      i.write("./public/m/#{filename}")
      {url: "#{$config['base_url']}/m/#{filename}"}
    rescue => e
      {error: e.message}
    end
  end
end


def image_search(term)
  query = URI.encode_www_form({
    q: term,
    fileType: 'jpg',
    imgColorType: 'color',
    imgSize: 'large',
    imgType: 'photo',
    num: '1',
    safe: 'medium',
    searchType: 'image',
    cx: $config['google_cx'],
    key: $config['google_server_key']
  })
  response = HTTParty.get "https://www.googleapis.com/customsearch/v1?#{query}"
  if response && response.parsed_response
    r = response.parsed_response
    if r['items'] && r['items'].length > 0
      return r['items'][0]['link']
    end
  end
  nil
end

