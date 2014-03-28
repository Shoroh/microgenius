include PostsHelper
class Post < ActiveRecord::Base
  # Добавляем теги к постам
  acts_as_taggable

  # Сколько постов на странице индекса?
  paginates_per 10

  # Перед валидацией ставим дефолты (если не поставленны в посте), ставим url поста (post_name), и превращаем название поста в ID.
  before_validation :set_post_name, to_param


  # Статус поста может быть только этими тремя значениями.
  validates :post_status, presence: true, inclusion: {in: %w(draft publish pending)}

  # Максимальная длина названия поста — 128 символов.
  validates :post_title, presence: true, length: {maximum: 128}

  # Ссылка на пост тоже должна быть не длиньше 128, а также уникальной.
  validates :post_name, presence: true, length: {maximum: 128}, uniqueness: true

  def to_param
    post_name
  end

  protected

  def set_defaults
    if self.post_name.blank?
      self.post_title = I18n.t('draft_title')
      self.post_status = 'draft'
      self.post_content = "Тут будет текст"
      self.post_type = "blog"
      self.comment_status = 'closed'
    end
  end

  # Делаем красивый URL для поста. Берем либо название темы, либо ID.
  def set_post_name
    if self.post_name.blank? and !self.post_title.blank?
      return self.post_name = self.post_title.to_url
    end
    if !self.post_name.blank? and !self.post_name.nil?
      self.post_name = self.post_name.to_url
    end
  end

end
