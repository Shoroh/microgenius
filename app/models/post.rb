include PostsHelper
class Post < ActiveRecord::Base
  before_validation :set_defaults, :set_post_name, :to_param
  before_save :post_content_verify

  validates :post_status, inclusion: { in: %w(draft publish pending)}
  validates :post_title, presence: true, length: {maximum: 128}
  validates :post_content, presence: true
  validates :post_name, presence: true, length: {maximum: 128}, uniqueness: true


  def to_param
    if post_name == "" || post_name == post_name.nil?
      id
    else
      post_name
    end
  end

  protected

    def post_content_verify
      # self.post_content = post_content
    end

  def set_defaults
      self.post_status ||= 'draft'
      self.post_title ||= t('draft_title')
    end

    # Делаем красивый URL для поста. Берем либо название темы, либо ID.
    def set_post_name
      if post_title.nil?
        self.post_name = self.id
      else
        if self.post_name.blank?
          self.post_name = self.post_title.to_url
        else
          self.post_name = self.post_name.to_url
        end
      end
    end

end
