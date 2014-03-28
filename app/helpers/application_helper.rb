module ApplicationHelper
  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  # Делаем активные ссылки в меню с классом active:
  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end

  def retina_link
    if session[:retina]
      content_tag(:li) do
        link_to 'Retina', retina_path, id: :retina, method: :post, remote: true
      end
    else
      content_tag(:li) do
        link_to 'Normal', retina_path, id: :retina, method: :post, remote: true
      end
    end
  end

end
