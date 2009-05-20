ActionController::Routing::Routes.draw do |map|
  map.resources :monkeys

  map.root :controller => 'monkeys'
end
