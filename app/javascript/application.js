// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "./controllers";
import "bootstrap";
import "bootstrap/dist/css/bootstrap.min.css";
import "bootstrap-icons";
import "bootstrap-icons/font/bootstrap-icons.css";
import "../assets/stylesheets/custom.css";

// <!-- Custom JS -->

document.addEventListener("DOMContentLoaded", function () {
  const body = document.body;
  const sidebarToggle = document.getElementById("sidebarToggle");

  // Toggle sidebar
  sidebarToggle.addEventListener("click", function () {
    body.classList.toggle("sidebar-collapsed");
  });

  // Handle initial state for mobile
  if (window.innerWidth <= 768) {
    body.classList.add("sidebar-collapsed");
  }

  // Handle window resize
  window.addEventListener("resize", function () {
    if (window.innerWidth <= 768) {
      body.classList.add("sidebar-collapsed");
    } else {
      body.classList.remove("sidebar-collapsed");
    }
  });
});
