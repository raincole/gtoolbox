var progressBar;
var dropArea;
var dropTip;
var configForm;
var fpsInput;
var spriteContainer;
var frameContainer;
var fileNameLabel;
var startStopButton;
var nextFrameButton;
var prevFrameButton;
var switchFrameTimerHandler;

var frames = [];

var LIGHT_BLUE = '#6482FA';
var LIGHT_GRAY = '#AAAAAA';
var GRAY = 'gray';

var animationRunning = false;
var currentFrameIndex = 0;

function exclusiveEvent(e) {
  if(e) {
    e.stopPropagation();
    e.preventDefault();
  }
}

function getFileIndex(fileName) {
  return parseInt(fileName.substring(0, fileName.lastIndexOf(".")).match(/[_|-]\d+$/)[0].substr(1));
}

function arrayLikeToArray(arrayLike) {
  var array = [];
  for(var i = 0; i < arrayLike.length; i++)
    array[i] = arrayLike[i];
  return array;
}

function hide(elem) {
  var currentDisplay = window.getComputedStyle(elem).display;
  if(currentDisplay !== 'none') {
    elem.dataset.oldDisplay = currentDisplay;
    elem.style.display = 'none';
  }
}

function show(elem) {
  var oldDisplay = elem.dataset.oldDisplay;
  var currentDisplay = window.getComputedStyle(elem).display;
  if(currentDisplay === 'none') {
    elem.style.display = oldDisplay;
  }
}

function init() {
  progressBar = document.querySelector('.load-progress');
  dropArea = document.querySelector('.drop-area');
  dropTip = dropArea.querySelector('.drop-tip');
  configForm = document.querySelector('form.config');
  fpsInput = configForm.querySelector('[name="fps"]');
  spriteContainer = document.querySelector('.sprite-container');
  frameContainer = spriteContainer.querySelector('.frame-container');
  fileNameLabel = spriteContainer.querySelector('.file-name');
  startStopButton = document.querySelector('#start-stop-button');
  nextFrameButton = document.querySelector('#next-frame-button');
  prevFrameButton = document.querySelector('#prev-frame-button');

  hide(progressBar);
  hide(fileNameLabel);
  startStopButton.disabled = true;
  nextFrameButton.disabled = true;
  prevFrameButton.disabled = true;

  dropArea.addEventListener('dragover', handleDragOver);
  dropArea.addEventListener('dragleave', handleDragLeave);
  dropArea.addEventListener('drop', handleFileSelect);
  startStopButton.addEventListener('click', toggleStartStop);
  nextFrameButton.addEventListener('click', nextFrame);
  prevFrameButton.addEventListener('click', prevFrame);
}

function handleFileSelect(e) {
  exclusiveEvent(e);

  var files = arrayLikeToArray(e.dataTransfer.files); // FileList object.
  files.sort(function(a, b) {
    return getFileIndex(a.name) - getFileIndex(b.name);
  });

  var loadedFrameCount = 0;
  frames = [];
  hide(dropTip);
  show(progressBar);
  progressBar.value = 0;
  if(switchFrameTimerHandler)
    clearTimeout(switchFrameTimerHandler);

  for (var i = 0, f; f = files[i]; i++) {
    // Only process image files.
    if (!f.type.match('image.*')) {
      continue;
    }

    var reader = new FileReader();

    reader.onload = (function(file, index) {
      return function(e) {
        var img = document.createElement('img');
        img.className = 'frame';
        img.src = e.target.result;
        img.title = file.name;
        img.onload = function() {
          img.style.width = this.width;
        };
        frames[index] = img;
        loadedFrameCount++;
        progressBar.value = loadedFrameCount / files.length;
        if(loadedFrameCount == files.length) {
          hide(progressBar);
          dropArea.style.borderColor = GRAY; 
          currentFrameIndex = 0;
          startAnimation();
        }
      };
    })(f, i);

    // Read in the image file as a data URL.
    reader.readAsDataURL(f);
  }
}

function handleDragOver(e) {
  exclusiveEvent(e);
  e.dataTransfer.dropEffect = 'copy';

  dropArea.style.borderColor = LIGHT_BLUE; 
  dropTip.style.color = LIGHT_BLUE;
}

function handleDragLeave(e) {
  exclusiveEvent(e);
  e.dataTransfer.dropEffect = 'copy';

  dropArea.style.borderColor = GRAY; 
  dropTip.style.color = GRAY;
}

function switchFrame(index) {
  var frame = frames[index];
  currentFrameIndex = index;
  frameContainer.innerHTML = '';
  if(!frame)
    console.log(frame);
  frameContainer.appendChild(frame);
  fileNameLabel.innerHTML = frame.title;

  if(animationRunning) {
    var frameDuration = 1 / parseInt(fpsInput.value);
    switchFrameTimerHandler = setTimeout(function() {
      nextFrame();
    }, frameDuration * 1000);
  }
}

function nextFrame(e) {
  exclusiveEvent(e);
  switchFrame((currentFrameIndex + 1) % frames.length);
}

function prevFrame(e) {
  exclusiveEvent(e);
  switchFrame((currentFrameIndex + frames.length - 1) % frames.length);
}

function startAnimation() {
  animationRunning = true;
  startStopButton.innerHTML = 'stop';
  startStopButton.disabled = false;
  nextFrameButton.disabled = true;
  prevFrameButton.disabled = true;
  hide(fileNameLabel);
  switchFrame(currentFrameIndex);
}

function stopAnimation() {
  animationRunning = false;
  startStopButton.innerHTML = 'start';
  startStopButton.disabled = false;
  nextFrameButton.disabled = false;
  prevFrameButton.disabled = false;
  show(fileNameLabel);
  if(switchFrameTimerHandler)
    clearTimeout(switchFrameTimerHandler);
}

function toggleStartStop(e) {
  exclusiveEvent(e);
  if(animationRunning) stopAnimation();
  else startAnimation();
}

init();
