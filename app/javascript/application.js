// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "@hotwired/stimulus"
import "bootstrap"

// Simple confirmation handler
document.addEventListener('DOMContentLoaded', function() {
  // Handle all forms with data-confirm
  document.addEventListener('submit', function(e) {
    const form = e.target;
    const confirmMessage = form.querySelector('[data-confirm]')?.getAttribute('data-confirm');
    
    if (confirmMessage && !confirm(confirmMessage)) {
      e.preventDefault();
      return false;
    }
  });
  
  // Handle links with confirmation
  document.addEventListener('click', function(e) {
    const link = e.target.closest('a[data-confirm]');
    if (link) {
      const confirmMessage = link.getAttribute('data-confirm');
      if (!confirm(confirmMessage)) {
        e.preventDefault();
        return false;
      }
    }
  });
});