// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener('turbo:load', (event) => {
  window.dataLayer = window.dataLayer || [];
  function gtag(){
    window.dataLayer.push(arguments);
  }
  gtag('js', new Date());
  gtag('config', 'G-3JW0EY2GYV', { page_location: event.detail.url });
  gtag('event', 'page_view', {
    page_location: event.detail.url,
    send_to: 'G-3JW0EY2GYV',
  });
});