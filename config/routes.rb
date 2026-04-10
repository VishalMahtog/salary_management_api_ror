Rails.application.routes.draw do
  devise_for :employees, path: "", path_names: { sign_in: "login", sign_out: "logout" },
  controllers: { sessions: "authentication/sessions" }


  namespace :hr do
    resources :employees
    resources :salaries, only: [] do
      collection do
        get :salary_stats
        get :job_title_stats
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
