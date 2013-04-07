User.destroy_all
Category.destroy_all
Article.destroy_all

User.create!(name: "test")

categories = Category.create!([
  { name: '阅读', en_name: "yue"},
  { name: '观点', en_name: "guan"},
  { name: '调查', en_name: "diao"},
  { name: '人物', en_name: "ren"}])

rand = Random.new

categories.each do |cat|
  rand.rand(10).times do |i|
    cat.articles.create!(title: "Test article #{i} in #{cat.name}", content: "Test article content in #{cat.name}", author: User.first)
  end
end