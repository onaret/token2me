class TokenPresenter < ApplicationPresenter

  def status(tag)
    content_tag(tag, token.status.capitalize, class: "token-status-"+token.status) 
  end

  def self.free_status(tag)
    content_tag(tag, "Free", class: "token-status-free") 
  end

  def created_at(tag)
    content_tag(tag, token.created_at.to_formatted_s(:short)) 
  end

  def updated_at(tag)
    content_tag(tag, token.updated_at.to_formatted_s(:short)) 
  end

end