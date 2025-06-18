document.addEventListener('DOMContentLoaded', function() {
  // Handle delete confirmations
  document.addEventListener('click', function(e) {
    const target = e.target;
    
    // Check if it's a delete link/button
    if (target.classList.contains('btn-outline-danger') || target.classList.contains('btn-danger')) {
      const confirmMessage = target.getAttribute('data-confirm') || 
                           target.getAttribute('data-turbo-confirm') || 
                           "Are you sure you want to delete this wager?";
      
      if (!confirm(confirmMessage)) {
        e.preventDefault();
        return false;
      }
    }
  });
});