# frozen_string_literal: true

# :nodoc:
module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def paginate_json(pagy)
    {
      current_page: pagy.page,
      total_pages: pagy.pages,
      total_count: pagy.count,
      per_page: pagy.items
    }
  end

  def format_validation_errors(errors)
    errors.messages.transform_values do |messages|
      messages.map(&:to_s)
    end
  end
end
