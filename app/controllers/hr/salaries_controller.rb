module Hr
  class SalariesController < Hr::BaseController
    before_action :set_paginate, only: %i[salary_stats job_title_stats]
    before_action :filter_employee, only: %i[salary_stats job_title_stats]

    def salary_stats
      stats_query = Employee.where(@conditions).group(:country).select(
        "country, MIN(salary) AS min_salary, MAX(salary) AS max_salary, AVG(salary) AS average_salary, COUNT(id) AS employee_count"
      ).order(:country)

      @pagy, @stats = pagy(stats_query, items: @per_page, page: @page)

      formatted_stats = @stats.map do |stat|
        {
          country: stat.country,
          min_salary: stat.min_salary,
          max_salary: stat.max_salary,
          average_salary: stat.average_salary.to_f.round(2),
          employee_count: stat.employee_count
        }
      end

      json_response(
        stats: formatted_stats,
        pagination: paginate_json(@pagy)
      )
    end

    def job_title_stats
      stats_query = Employee.where(@conditions).group(:country, :job_title).select(
        "country, job_title, MIN(salary) AS min_salary, MAX(salary) AS max_salary, AVG(salary) AS average_salary, COUNT(id) AS employee_count"
      ).order(:country, :job_title)

      @pagy, @stats = pagy(stats_query, items: @per_page, page: @page)

      formatted_stats = @stats.group_by(&:country).map do |country, stats|
        {
          country: country,
          job_titles: stats.map do |stat|
            {
              job_title: stat.job_title,
              min_salary: stat.min_salary,
              max_salary: stat.max_salary,
              average_salary: stat.average_salary.to_f.round(2),
              employee_count: stat.employee_count
            }
          end
        }
      end

      json_response(
        stats: formatted_stats,
        pagination: paginate_json(@pagy)
      )
    end

    private

    def filter_employee
      build_condition :country, operator: "like"
    end
  end
end
