# frozen_string_literal: true

# :nodoc:
module ConditionConcern
  extend ActiveSupport::Concern

  protected

  # Build SQL Condition methods
  # Examples:
  #   build_condition :column_name
  #   build_condition :column_name, value: 1
  #   build_condition :column_name, operator: '!=', value: true
  #   build_condition :column_name, value: 'xyz', operator: 'like', column: 'amount'
  #   build_condition :column_name, operator: 'between', value: 1, other_value: 20, column: 'amount'
  def build_condition(column_name, **args)
    @conditions ||= []
    value = args[:value] || params[column_name]
    return nil if value.blank?

    operator = args[:operator] || "="
    other_value = operator == "between" ? args[:other_value] : nil
    column = args[:column] || column_name.to_s
    @conditions[0] = prepare_condition(column, operator)
    @conditions.concat(Array(prepare_value(operator, value, other_value)))
  end

  def set_sort(default_column: "created_at", default_order: "desc")
    sort_column = params[:sort_column] || default_column
    sort_order = params[:sort_order] || default_order

    sort_order = default_order unless %w[asc desc].include?(sort_order.downcase)
    @sort = "#{sort_column} #{sort_order}"
  end

  def prepare_condition(column, operator)
    @conditions[0].to_s +
      (@conditions[0].blank? ? "" : " and ") + "#{column} #{operator} " + (operator == "between" ? "? and ?" : "?")
  end

  def prepare_value(operator, value, other_value)
    case operator
    when "=", "!=", ">=", "<=", ">", "<", "IN"
      value
    when "like", "ilike"
      "%#{value.strip}%"
    when "between"
      [ value, other_value ]
    end
  end
end
