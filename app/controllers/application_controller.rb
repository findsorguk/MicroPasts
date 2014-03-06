# coding: utf-8
class ApplicationController < ActionController::Base
  include Concerns::ExceptionHandler
  include Concerns::SocialHelpersHandler

  layout :application
  protect_from_forgery
  before_filter :require_basic_auth

  before_filter :set_return_to, if: -> { !current_user && params[:redirect_to].present? }
  before_filter :redirect_user_back_after_login, unless: :devise_controller?
  before_filter :configure_permitted_parameters, if: :devise_controller?
  helper_method :channel, :referal_link, :total_with_fee

  before_filter :force_http
  before_action :referal_it!
  after_action :needs_confirm_account, unless: -> { request.xhr? }
  after_action :complete_profile, unless: -> { request.xhr? }

  before_filter do
    if current_user and (current_user.email =~ /change-your-email\+[0-9]+@micropasts\.org/)
      redirect_to set_email_users_path unless controller_name =~ /users|confirmations/
    end
  end
  #
  # TODO: REFACTOR
  include ActionView::Helpers::NumberHelper
  def total_with_fee(contribution, payment_method)
    if payment_method == 'paypal'
      value = (backer.value * 1.029)+0.30
    else
      value = contribution.value
    end
    number_to_currency value, :unit => "£", :precision => 2, :delimiter => ','
  end

  def channel
    Channel.find_by_permalink(request.subdomain.to_s)
  end

  def number_to_pounds (number, options = {})
    options[:unit] = '&pound;' unless options[:unit]
    number_to_currency(number, options) if number
  end

  def referal_link
    session[:referal_link]
  end

  private
  def set_return_to
    if params[:redirect_to].present?
      session[:return_to] = params[:redirect_to]
      flash[:devise_error] = t('devise.failure.unauthenticated')
    end
  end

  def needs_confirm_account
    if current_user && !current_user.confirmed?
      flash[:notice_confirmation] = { message: t('devise.confirmations.confirm', link: new_user_confirmation_path), dismissible: false }
    end
  end

  def complete_profile
    if current_user && current_user.completeness_progress.to_i < 100
      flash[:notice_completeness_progress] = { message: t('controllers.users.completeness_progress', link: edit_user_path(current_user)), dismissible: false }
    end
  end

  def referal_it!
    session[:referal_link] = params[:ref] if params[:ref].present?
  end

  def after_sign_in_path_for(resource_or_scope)
    return_to = session[:return_to]
    session[:return_to] = nil
    (return_to || root_path)
  end

  def force_http
    redirect_to(protocol: 'http', host: ::Configuration[:base_domain]) if request.ssl?
  end

  def redirect_user_back_after_login
    if request.env['REQUEST_URI'].present? && !request.xhr?
      session[:return_to] = request.env['REQUEST_URI']
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :password, :newsletter)
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, { channel: channel })
  end

  def require_basic_auth
    black_list = ['crowdfunding.micropasts.org']

    if request.url.match Regexp.new(black_list.join("|"))
      authenticate_or_request_with_http_basic do |username, password|
        username == 'micropasts' && password == 'gr8tcour1'
      end
    end
  end
end
