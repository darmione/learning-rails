require_relative 'post'
require 'sinatra'

@@posts ||= [
  Post.new('Ruby', 'Ruby is great!', ['#ruby']),
  Post.new('Rails', 'Rails is magical.', ['#rails']),
  Post.new('Sinatra', 'Frank Sinatra', ['#ruby', '#rails'])
]

get '/' do
  if @@posts == nil || @@posts.empty?
    "<h1>There is no blog posts yet</h1>"
  else
    render_posts(@@posts)
  end
end

post '/new' do
  if params[:description].length <= 256
    @@posts << Post.new(params[:name], params[:description])
    '<h1>Successfully added.</h1>'
  else
    '<h1>Description should be not longer than 256 characters.</h1>'
  end
end

get '/:id' do
  begin
    post = @@posts.fetch(params[:id].to_i)
    render_posts([post])
  rescue IndexError
    not_found
  end
end

delete '/:id' do
  begin
    @@posts.delete_at(params[:id].to_i)
    '<h1>Successfully deleted.</h1>'
  rescue IndexError
    not_found
  end
end

get '/search/:tag' do
  posts = @@posts.select { |post| post.tags.include?("\##{params[:tag]}")}

  render_posts(posts)

end

def render_posts(posts)
  posts.map do |post|
    "<h1>#{post.name}</h1>
     <p>#{post.description}</p>
     <p>#{post.tags.join(', ')}</p>"
  end.join("======================<br>")
end

not_found do
  status 404
  '<h1>Not found</h1>'
end
