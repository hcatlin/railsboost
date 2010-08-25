class Admin::CommandsController < ApplicationController
  before_filter :ip_check, :except => "index"
  layout 'admin'
  
  make_resourceful do
    build :all
    
    response_for :index do |format|
      format.html
      format.yaml do
        @commands.collect! do |command|
          command.attributes
        end
        render :text => @commands.to_yaml
      end
    end
    
    response_for :create, :update, :destroy do
      redirect_to admin_commands_path
    end
  end
  
 private
 
  # Yes, this is a hack, but its not worth it at this point to write a whole auth system
  def ip_check
    logger.warn request.remote_addr.inspect
    if Rails.env == "production" && !["77.250.47.10", "99.166.163.112"].include?(request.remote_ip)
      render :text => "GETTHEFUCKOUT"
    end
  end
 
  def build_object
    @current_object ||= params[:type].constantize.new(params[:command])
  end

end
