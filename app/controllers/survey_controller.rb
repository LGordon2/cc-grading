require 'matrix'
class Matrix
  public :"[]=", :set_element, :set_component
end
class SurveyController < ApplicationController

    before_action :require_admin

	def index
		
		@survey = Survey.new
		
	end
	
	def create
		
		Survey.create(survey_params)
	end
	
	def result
		if params[:id]
		 @surveys = Survey.where(id: params[:id])
		else
		 @surveys = Survey.all
		end
		
		if params[:filter]
			@filter = params[:filter]
		end
	end
	
	def require_admin
		redirect_to :root unless current_user and current_user.admin
	end
	
	def survey_params
		params.require(:survey).permit(:haveParticipated,:whyStart, :newSkills, :howUsedSkills, :skillsExample, :whyNot, :whatWouldInterest, :whatWouldIncreaseParticipation, :bestLeague, :automation, :otherDevelopment, :betterServe)
	end
	
end
