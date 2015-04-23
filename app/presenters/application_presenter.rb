class ApplicationPresenter < SimpleDelegator

  attr_reader :article

  def initialize(article, view)
    @article, @view = article, view
    define_singleton_method(article.class.name.downcase.to_sym, method(:article))
    super(@view)
  end

end