class ApplicationController < ActionController::Base
  before_action :configure_devise_params, if: :devise_controller?

  def configure_devise_params
    devise_parameter_sanitizer.permit(:sign_up) do |user|
       user.permit(:first_name, :last_name, :email, :cellphone, :address, :password)
     end
  end

  def is_propietary!(stuff)
    unless current_user.id == stuff.user.id
      flash[:notice] = 'Only the owner of the product can do this action'
      redirect_to stuff
    end
  end
end
