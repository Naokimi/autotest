const btnAll = document.getElementById('btnAll')
const allBtn = document.querySelectorAll('.special');

if (btnAll) {

  btnAll.addEventListener('click', () => {
    allBtn.forEach((event) => {
      event.click();
    });
  });
}
