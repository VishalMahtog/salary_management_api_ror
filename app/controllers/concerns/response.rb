# frozen_string_literal: true

# :nodoc:
module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def paginate_json(page)
    {
      current_page: page.page,
      total_pages: page.pages, total_count: page.count,
      first_page: 1, last_page: page.pages
    }
  end

  def format_validation_errors(errors)
    errors.messages.transform_values do |messages|
      messages.map(&:to_s)
    end
  end
end
