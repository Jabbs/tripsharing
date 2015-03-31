class SurveysController < ApplicationController
  
  # def create
  #   raise ActionController::RoutingError.new('Not Found') if !params[:blanky].blank?
  #   @survey = Survey.new(companion_count: params[:companion_count], destination: params[:destination],
  #                       month: params[:month], companion_type: params[:companion_type],
  #                       organizer_type: params[:organizer_type])
  #   
  #   if @survey.save
  #     cookies[:survey_id] = @survey.id
  #     respond_to do |format|
  #       format.js
  #     end
  #   else
  #     redirect_to root_path alert: "The application encountered an issue."
  #   end
  # end
end
