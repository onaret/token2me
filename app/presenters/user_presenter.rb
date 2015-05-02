class UserPresenter < ApplicationPresenter

  def team(tag)
    if user.team == current_user.team
      content_tag(tag, user.team.capitalize, class: "team-"+user.team + " bold")
    else
      content_tag(tag, user.team.capitalize, class: "team-"+user.team)
    end
  end

end