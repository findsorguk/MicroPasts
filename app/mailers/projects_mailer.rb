class ProjectsMailer < ActionMailer::Base
  layout 'email'

  def contact_about_reward_email(params, project)
    @params = params
    @project = project

    mail(
      from: "#{::Configuration[:company_name]} <#{::Configuration[:email_system]}>",
      to: 'info@micropasts.org',
      subject: "Contact about reward of project #{@project.name}."
    )
  end
end
