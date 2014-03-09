module PostsHelper

  # Превращение любой строки в валидный и красивый URL
  def to_url
    self.to_slug.transliterate(:russian).normalize.to_s
  end

end
