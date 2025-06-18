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

  // Bootstrap form validation
  const forms = document.querySelectorAll('.needs-validation');
  Array.from(forms).forEach(form => {
    form.addEventListener('submit', event => {
      if (!form.checkValidity()) {
        event.preventDefault();
        event.stopPropagation();
      }
      form.classList.add('was-validated');
    });
  });

  // Real-time validation feedback
  document.querySelectorAll('input[required], select[required], textarea[required]').forEach(input => {
    input.addEventListener('blur', function() {
      if (this.checkValidity()) {
        this.classList.remove('is-invalid');
        this.classList.add('is-valid');
      } else {
        this.classList.remove('is-valid');
        this.classList.add('is-invalid');
      }
    });

    input.addEventListener('input', function() {
      if (this.classList.contains('was-validated') || this.classList.contains('is-invalid')) {
        if (this.checkValidity()) {
          this.classList.remove('is-invalid');
          this.classList.add('is-valid');
        } else {
          this.classList.remove('is-valid');
          this.classList.add('is-invalid');
        }
      }
    });
  });
});