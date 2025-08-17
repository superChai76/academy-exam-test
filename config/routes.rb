Rails.application.routes.draw do
  get "brag/show"
  resources :quests do
  member { patch :toggle_done }
end

  get "/brag", to: "brag#show"

  root "quests#index"
end
