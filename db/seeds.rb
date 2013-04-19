Setting.destroy_all
User.destroy_all
Category.destroy_all
Article.destroy_all
Feature.destroy_all
Vote.destroy_all

Setting.create!(background: File.open(File.join(Rails.root, '/public/test4.jpg')))

User.create!(name: "test", power: 100)
User.create!(name: "reporter", power: 1)
User.create!(name: "student", power: 0)

categories = Category.create!([
  { name: '阅读' },
  { name: '观点' },
  { name: '调查' },
  { name: '人物' }])

rand = Random.new

content = <<_EOF_
<p style="text-indent:2em;">测试数据。</p>
<p style="text-indent:2em;">这是一段话，用于银杏时报的网站的测试。这是一段话，用于银杏时报的网站的测试。这是一段话，用于银杏时报的网站的测试。这是一段话，用于银杏时报的网站的测试。</p>
<p style="text-indent:2em;">这是一段话，用于银杏时报的网站的测试。这是一段话，用于银杏时报的网站的测试。这是一段话，用于银杏时报的网站的测试。这是一段话，用于银杏时报的网站的测试。</p>
<p style="text-indent:2em;">这是一段话，用于银杏时报的网站的测试。这是一段话，用于银杏时报的网站的测试。这是一段话，用于银杏时报的网站的测试。这是一段话，用于银杏时报的网站的测试。</p>
<p style="text-indent:2em;">测试数据。</p>
_EOF_

categories.each do |cat|
  cat.articles.create!(title: "#{cat.name}中的测试文章", content: content, source: "www.pkuschool.edu.cn", author: User.first, is_verified: true)
end

# with imgs
Category.renwu.articles.create!(title: "一个伟大的人", content: content + "<img src=\"/test3.png\" >", author: User.first, is_verified: true)
Category.diaocha.articles.create!(title: "北大附中", content: content + "<img src=\"/test2.jpg\" >", author: User.first, is_verified: true, read_count: 10)


Category.diaocha.articles.create!(title: "未审查的文章", content: content, author: User.first)
Category.yuedu.articles.create!(title: "未审查的文章", content: content, author: User.first)


feature = Feature.create!(title: "测试专题", content: "这是一个测试专题。里边有一些文章。", articles: Article.all[1..4], poster: File.open(File.join(Rails.root, '/public/test.jpg')))

vote = Vote.create!(title: "测试投票 1", options: (1..4).map{|i|Vote::Option.new(content: "选项" + i.to_s)})
vote = Vote.create!(title: "测试投票 2", options: (1..4).map{|i|Vote::Option.new(content: "选项" + i.to_s)})
