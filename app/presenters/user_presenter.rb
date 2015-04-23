class UserPresenter < ApplicationPresenter

  def team(tag)
    content_tag(tag, user.team.capitalize, class: "team-"+user.team)
  end

=begin
    case user.team
      when user.silver?
        content_tag(:span, "Hello world!", class: ["strong", "highlight"])
      when user.black?

      when user.pink?

      when user.red?

      when user.orange?

      else
=end


end