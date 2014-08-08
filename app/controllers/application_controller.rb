class ApplicationController < ActionController::Base

  before_filter :set_limit_if_page_is_specified

  def root
    home = {welcome: 'home'}
    render json: home
  end

  def render_response(controller_response)
    render json: {meta: meta, results: controller_response}
  end

  private

  def set_limit_if_page_is_specified
    if params[:page]
      params[:limit] ||= Rails.configuration.DEFAULT_PER_PAGE
    end
  end

  def meta
    {
      meta: {
        page: (params[:page] || 1),
        limit: (params[:limit] || 'all'),
        count: @count
      }
    }
  end
end
