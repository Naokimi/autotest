btnSave = document.getElementById('save');
bodyElement = document.querySelector('body');

if (btnSave) {
  console.log("de");

  btnSave.addEventListener('click', () => {
  bodyElement.insertAdjacentHTML("afterbegin", "<div class='uploading'><h2 class='text-primary'></h2></div>");
  });
}

