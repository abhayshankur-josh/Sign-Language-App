// app/javascript/detection.js
// This would be included in your application.js or as a separate pack

document.addEventListener('DOMContentLoaded', function() {
  const startCameraBtn = document.getElementById('startCamera');
  const stopCameraBtn = document.getElementById('stopCamera');
  const cameraPlaceholder = document.getElementById('cameraPlaceholder');
  const video = document.getElementById('video');
  const canvas = document.getElementById('canvas');
  const detectionResults = document.getElementById('detectionResults');
  const clearResultsBtn = document.getElementById('clearResults');
  const saveResultsBtn = document.getElementById('saveResults');
  const modelSelect = document.getElementById('modelSelect');
  
  let stream = null;
  let mediaRecorder = null;
  let recordedChunks = [];
  let recordingInterval = null;
  let isRecording = false;
  const CLIP_DURATION = 5; // seconds
  
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
      stopCameraBtn.style.display = 'block';
      
      // Update button states
      startCameraBtn.disabled = true;
      startCameraBtn.textContent = 'Camera On';
      
      // Start the video recording at regular intervals
      startVideoRecordingCycle();
    } catch (err) {
      console.error('Error accessing camera:', err);
      detectionResults.value = 'Error accessing camera. Please check permissions.';
    }
  });
  
  // Stop camera
  stopCameraBtn.addEventListener('click', function() {
    if (stream) {
      // Stop any active recording
      if (mediaRecorder && mediaRecorder.state !== 'inactive') {
        mediaRecorder.stop();
      }
      
      // Clear recording interval
      if (recordingInterval) {
        clearTimeout(recordingInterval);
        recordingInterval = null;
      }
      
      // Stop all tracks
      stream.getTracks().forEach(track => track.stop());
      
      // Hide video and show placeholder
      video.style.display = 'none';
      cameraPlaceholder.style.display = 'block';
      stopCameraBtn.style.display = 'none';
      
      // Update button states
      startCameraBtn.disabled = false;
      startCameraBtn.textContent = 'Start Camera';
      
      isRecording = false;
    }
  });
  
  // Function to start video recording cycle
  function startVideoRecordingCycle() {
    // Only start if camera is active
    if (!stream) return;
    
    // Set an initial delay before starting to allow camera to fully initialize
    setTimeout(() => {
      startRecording();
    }, 1000);
  }
  
  // Function to start recording
  function startRecording() {
    if (isRecording || !stream) return;
    
    // Reset recorded chunks
    recordedChunks = [];
    
    // Create a new MediaRecorder instance
    try {
      mediaRecorder = new MediaRecorder(stream, { 
        mimeType: 'video/webm;codecs=vp9' 
      });
    } catch (e) {
      try {
        // Fallback for Safari
        mediaRecorder = new MediaRecorder(stream, { 
          mimeType: 'video/mp4' 
        });
      } catch (e2) {
        // Last resort fallback
        mediaRecorder = new MediaRecorder(stream);
      }
    }
    
    // Event handler for data available
    mediaRecorder.ondataavailable = (event) => {
      if (event.data && event.data.size > 0) {
        recordedChunks.push(event.data);
      }
    };
    
    // Event handler for when recording stops
    mediaRecorder.onstop = () => {
      isRecording = false;
      
      // Create a Blob from the recorded chunks
      const videoBlob = new Blob(recordedChunks, { type: 'video/webm' });
      
      // Process the video
      processVideoOnServer(videoBlob);
      
      // Schedule the next recording after a pause
      if (stream && stream.active) {
        setTimeout(() => {
          startRecording();
        }, 5000); // 5 second pause between recordings
      }
    };
    
    // Start recording
    mediaRecorder.start();
    isRecording = true;
    detectionResults.value = 'Recording 5-second video clip...';
    
    // Stop recording after clip duration
    setTimeout(() => {
      if (mediaRecorder && mediaRecorder.state !== 'inactive') {
        mediaRecorder.stop();
      }
    }, CLIP_DURATION * 1000);
  }
  
  // Process the video on the server
  function processVideoOnServer(videoBlob) {
    const selectedModel = modelSelect.value;
    
    // Set loading state
    detectionResults.value = 'Processing 5-second video clip...';
    
    // Create form data to send to the server
    const formData = new FormData();
    formData.append('model_type', selectedModel);
    formData.append('file', videoBlob, 'recording.webm'); // Send as a file with a name
    console.log(formData);
    
    // Send to API backend with CSRF token
    fetch('http://localhost:8000/predict', {
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
        detectionResults.value = data.gesture;
      } else {
        detectionResults.value = 'Error: ' + (data.message || 'Unknown error');
      }
    })
    .catch(error => {
      console.error('Error processing video:', error);
      detectionResults.value = 'Error processing video. Please try again.';
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
      // Create a thumbnail from the last frame
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