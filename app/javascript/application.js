// application.js

import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("turbo:load", function() {
  // Inicializa tooltips
  const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
  const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl);
  });

  // En caso de usar dropdown lo resetea
  // Resetear dropdown después de seleccionar una opción
  const dropdownItems = document.querySelectorAll('.dropdown-item');
  dropdownItems.forEach(item => {
    item.addEventListener('click', function() {
      const dropdownToggle = item.closest('.dropdown').querySelector('.dropdown-toggle');
      let dropdown = bootstrap.Dropdown.getInstance(dropdownToggle);

      if (dropdown) {
        dropdown.hide();  // Cierra el dropdown
        bootstrap.Dropdown.clearMenus(); // Cierra cualquier menú abierto para asegurar limpieza
        dropdown.dispose(); // Destruye la instancia actual del dropdown

        // Reinicia la instancia del dropdown para que esté listo para el siguiente uso
        dropdown = new bootstrap.Dropdown(dropdownToggle);
      }
    });
  });
});

  
