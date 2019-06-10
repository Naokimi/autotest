function move() {
  var element = document.getElementById("myBar");
  var width = 1;
  var id = setInterval(frame, 15);
  function frame() {
    if (width >= 100) {
      clearInterval(id);
    } else {
      width++;
      element.style.width = width + '%';
    }
  }
}

export { move }
