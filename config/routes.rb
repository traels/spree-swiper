Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  get 'swiper/paid', to: 'swiper_payment#paid'
end
