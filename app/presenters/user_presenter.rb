class UserPresenter < ApplicationPresenter

  def team(tag)
      content_tag(tag, user.team.capitalize, class: "team-"+user.team)
  end

  def name(tag)
      content_tag(tag, user.name)
  end

end