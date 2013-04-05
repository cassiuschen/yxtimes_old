Collection.destroy_all
Article.destroy_all

collection = Collection.create!(name: 'Collect')

article = Article.new(title: 'Test title', content: 'Test content')
article.collection = collection
article.save!