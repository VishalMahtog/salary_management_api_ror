Rails.application.routes.draw do
  devise_for :employees, path: "", path_names: { sign_in: "login", sign_out: "logout"},
  controllers: { sessions: "authentication/sessions"}

  get "up" => "rails/health#show", as: :rails_health_check
end
