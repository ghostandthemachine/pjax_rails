module Pjax
  extend ActiveSupport::Concern

  included do
    layout proc { |c| pjax_request? ? pjax_layout : 'application' }
    helper_method :pjax_request?

    before_filter :strip_pjax_param, :if => :pjax_request?
    around_filter :set_pjax_url, :if => :pjax_request?
  end

  protected
    def pjax_request?
      env['HTTP_X_PJAX'].present?
    end

    def pjax_layout
      false
    end

    def strip_pjax_param
      params.delete(:_pjax)
      request.env['QUERY_STRING'] = Rack::Utils.build_query(params)

      request.env.delete('rack.request.query_string')
      request.env.delete('rack.request.query_hash')
      request.env.delete('action_dispatch.request.query_parameters')
    end

    def set_pjax_url
      yield
      response.headers['X-PJAX-URL'] = request.url
    end
end
