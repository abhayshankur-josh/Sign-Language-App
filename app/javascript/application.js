// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "./controllers";
import "bootstrap";
import "bootstrap/dist/css/bootstrap.min.css";
import "../assets/stylesheets/custom.css";

// <!-- Custom JS -->

document.addEventListener("turbo:load", function () {
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


// app/javascript/detection.js
// This would be included in your application.js or as a separate pack

document.addEventListener('turbo:load', function() {
  const startCameraBtn = document.getElementById('startCamera');
  const stopCameraBtn = document.getElementById('stopCamera');
  const captureBtn = document.getElementById('captureImage');
  const cameraPlaceholder = document.getElementById('cameraPlaceholder');
  const video = document.getElementById('video');
  const canvas = document.getElementById('canvas');
  const detectionResults = document.getElementById('detectionResults');
  const clearResultsBtn = document.getElementById('clearResults');
  const saveResultsBtn = document.getElementById('saveResults');
  const modelSelect = document.getElementById('modelSelect');
  
  let stream = null;
  
  // Start camera
  startCameraBtn.addEventListener('click', async function() {
    try {
      stream = await navigator.mediaDevices.getUserMedia({ 
        video: { 
          width: { ideal: 1280 },
          height: { ideal: 720 },
          facingMode: 'user' 
        } 
      });
      
      video.srcObject = stream;
      
      // Show video and hide placeholder
      video.style.display = 'block';
      cameraPlaceholder.style.display = 'none';
      
      // Update button states
      startCameraBtn.disabled = true;
      stopCameraBtn.disabled = false;
      captureBtn.disabled = false;
    } catch (err) {
      console.error('Error accessing camera:', err);
      detectionResults.value = 'Error accessing camera. Please check permissions.';
    }
  });
  
  // Stop camera
  stopCameraBtn.addEventListener('click', function() {
    if (stream) {
      stream.getTracks().forEach(track => track.stop());
      
      // Hide video and show placeholder
      video.style.display = 'none';
      cameraPlaceholder.style.display = 'block';
      
      // Update button states
      startCameraBtn.disabled = false;
      stopCameraBtn.disabled = true;
      captureBtn.disabled = true;
    }
  });
  
  // Capture image
  captureBtn.addEventListener('click', function() {
    if (video.style.display === 'block') {
      const ctx = canvas.getContext('2d');
      canvas.width = video.videoWidth;
      canvas.height = video.videoHeight;
      ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
      
      // Get the image data
      const imageData = canvas.toDataURL('image/jpeg');
      
      // Send the image to the backend for processing
      processImageOnServer(imageData);
    }
  });
  
  // Process the image on the server
  function processImageOnServer(imageData) {
    const selectedModel = modelSelect.value;
    
    // Set loading state
    detectionResults.value = 'Processing...';
    
    // Create form data to send to the server
    const formData = new FormData();
    formData.append('model_type', selectedModel);
    formData.append('image_data', imageData);
    
    // Send to Rails backend with CSRF token
    fetch('/detections/process_image', {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        'Accept': 'application/json'
      },
      body: formData
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        detectionResults.value = data.result;
      } else {
        detectionResults.value = 'Error: ' + (data.message || 'Unknown error');
      }
    })
    .catch(error => {
      console.error('Error processing image:', error);
      detectionResults.value = 'Error processing image. Please try again.';
    });
  }
  
  // Clear results
  clearResultsBtn.addEventListener('click', function() {
    detectionResults.value = '';
  });
  
  // Save results
  saveResultsBtn.addEventListener('click', function() {
    const selectedModel = modelSelect.value;
    const resultText = detectionResults.value.trim();
    
    if (!resultText) {
      alert('No results to save!');
      return;
    }
    
    // Get the image data
    let imageData = null;
    if (canvas.width > 0) {
      imageData = canvas.toDataURL('image/jpeg');
    }
    
    // Create form data
    const formData = new FormData();
    formData.append('model_type', selectedModel);
    formData.append('result_text', resultText);
    if (imageData) {
      formData.append('image_data', imageData);
    }
    
    // Send to Rails backend
    fetch('/detections/save_result', {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        'Accept': 'application/json'
      },
      body: formData
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        alert('Results saved successfully!');
      } else {
        alert('Error: ' + (data.message || 'Unknown error'));
      }
    })
    .catch(error => {
      console.error('Error saving results:', error);
      alert('Error saving results. Please try again.');
    });
  });
  
  // Switch camera (if multiple cameras are available)
  let currentFacingMode = 'user';
  
  function switchCamera() {
    if (stream) {
      // Stop the current stream
      stream.getTracks().forEach(track => track.stop());
      
      // Switch facing mode
      currentFacingMode = currentFacingMode === 'user' ? 'environment' : 'user';
      
      // Get new stream with updated facing mode
      navigator.mediaDevices.getUserMedia({
        video: {
          facingMode: currentFacingMode
        }
      })
      .then(newStream => {
        stream = newStream;
        video.srcObject = stream;
      })
      .catch(err => {
        console.error('Error switching camera:', err);
        detectionResults.value = 'Error switching camera. Please try again.';
      });
    }
  }
  
  // You could add a switch camera button if needed
  // const switchCameraBtn = document.getElementById('switchCamera');
  // switchCameraBtn.addEventListener('click', switchCamera);
});