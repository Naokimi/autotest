btnSave = document.getElementById('save');
bodyElement = document.querySelector('body');

if (btnSave) {
  console.log("de");

  btnSave.addEventListener('click', () => {
  document.getElementById('canvas2').remove();
  bodyElement.insertAdjacentHTML("afterbegin", "<div class='uploading-brain'><h2 class='text-primary'>Analyzing exam's answers...</h2></div>");  });
}

