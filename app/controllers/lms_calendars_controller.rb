class LmsCalendarsController < ApplicationController
  unloadable
  include LeaveManagementSystem::Controller

  rescue_from Query::StatementInvalid, :with => :query_statement_invalid

  helper :queries
  include QueriesHelper
  helper :sort
  include SortHelper
  
  def create  
  end

  def show
    if params[:year] and params[:year].to_i > 1900
      @year = params[:year].to_i
      if params[:month] and params[:month].to_i > 0 and params[:month].to_i < 13
        @month = params[:month].to_i
      end
    end
    @year ||= Date.today.year
    @month ||= Date.today.month

    @calendar = Redmine::Helpers::Calendar.new(Date.civil(@year, @month, 1), current_language, :month)
    retrieve_query
    @query.group_by = nil

    @public_holidays = LmsPublicHoliday.find(:all, :select => "ph_date")

    render :action => 'show', :layout => false if request.xhr?
  end

end
