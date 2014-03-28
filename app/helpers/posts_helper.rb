module PostsHelper

  # Превращение любой строки в валидный и красивый URL
  def to_url
    self.to_slug.transliterate(:russian).normalize.to_s
  end

  # Вычленяем анонс
  def cut_head(post, key = '<!--more-->')
    output = post.post_content.split(key) # Делим пост на две части, анонс и основную.
    if output[1] # Если есть вторая часть, то добавляем в конце поста ссылку на полный пост:
      output.first << link_to('Читать далее...', post, class: 'pull-right', target: '_blank') #делаем ссылку на полный пост
    end
    output.first # Выводим анонс.
  end

  # разбивка на параграфы — добавление к ним якорей
  def by_p(text)
    output = Array.new
    pid = 1
    paragraphs = text.split('<p>') # Для разибвки используется тег <p>
    paragraphs.delete_at(0)
    if paragraphs.count <= 3 # Если параграфов меньше 3-х, значит их разбивка не требуется.
      return text
    end

    # Добавляем якоря к параграфам
    paragraphs.each do |p|
      anchor = '<p><a class="anchor" href="#' + pid.to_s + '" id="' + pid.to_s + '" name="' + pid.to_s + '" >' + pid.to_s + '</a>'
      output << anchor
      output << p
      pid +=1
    end
    output.join()
  end

  # Делаем все картинки в посте — Retina @2x
  def retinized(text)
    output = Array.new
    pictures = text.split('.jpg')
    pictures.each do |p|
      if !(p == pictures.last)
        element = p + '@2x' + '.jpg'
        output << element
      else
        output << p
      end
    end
    output.join()
  end


end
