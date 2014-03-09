json.array!(@posts) do |post|
  json.extract! post, :id, :post_date, :post_title, :post_content, :post_status, :comment_status, :post_name, :post_type
  json.url post_url(post, format: :json)
end
