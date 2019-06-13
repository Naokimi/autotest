btnSave = document.getElementById('save');
bodyElement = document.querySelector('body');

if (btnSave) {
  btnSave.addEventListener('click', () => {
    bodyElement.insertAdjacentHTML("afterbegin", "<div class='uploading'><h2 class='text-primary'>tded</h2></div>");
  });
}

