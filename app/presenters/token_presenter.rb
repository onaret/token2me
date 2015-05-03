class TokenPresenter < ApplicationPresenter


=begin
  def status
#    class="token-status-"+token.status + token.status.capitalize
    content_tag(:td, token.status.capitalize, class: "token-status-"+token.status)
  end

  def self.free_status
    "Free", class: "token-status-free"
  end

  def created_at
    token.created_at.to_formatted_s(:short)
  end

  def updated_at(tag)
    content_tag(tag, token.updated_at.to_formatted_s(:short)) 
  end

=end

  def status(tag)
    content_tag(tag, token.status.capitalize, class: "token-status-"+token.status) 
  end

  def self.free_status(tag)
    content_tag(tag, "Free", class: "token-status-free") 
  end

  def created_at(tag)
    content_tag(tag, token.created_at.to_formatted_s(:short)) 
  end

  def comment(tag)
    content_tag(tag, token.comment)
  end

=begin
  def comment(tag)
      content_tag tag do
        content_tag(:span, token.comment, class: "col-md-6 nowrap")
      end
  end
=end

end