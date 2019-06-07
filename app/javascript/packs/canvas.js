var canvas = document.getElementById('canvas');
if (canvas) {
var ctx = canvas.getContext('2d');
var rect = {};
var drag = false;
var imageObj = null;
const el = document.getElementById('area');
var elcanvas = el.dataset.canvas
function init() {
     imageObj = new Image();
     imageObj.onload = function () { ctx.drawImage(imageObj, 0, 0); };
     imageObj.src =elcanvas;
     canvas.addEventListener('mousedown', mouseDown, false);
     canvas.addEventListener('mouseup', mouseUp, false);
     canvas.addEventListener('mousemove', mouseMove, false);
 }

 function mouseDown(e) {
     rect.startX = e.pageX - this.offsetLeft;
     rect.startY = e.pageY - this.offsetTop;
     drag = true;
 }

function mouseUp(e) {
     console.log(rect)
     document.getElementById('area').innerHTML=`${rect.h}-${rect.w}-${rect.startX}-${rect.startY}`;
     document.getElementById('exam_origin_x').value =rect.startX;
     document.getElementById('exam_origin_y').value =rect.startY;
     document.getElementById('exam_width').value =rect.w;
     document.getElementById('exam_height').value =rect.h;


     drag = false;
}

function mouseMove(e) {
    if (drag) {
        ctx.clearRect(0, 0, 500, 500);
        ctx.drawImage(imageObj, 0, 0);
        rect.w = (e.pageX - this.offsetLeft) - rect.startX;
        rect.h = (e.pageY - this.offsetTop) - rect.startY;
        ctx.strokeStyle = 'red';
        ctx.strokeRect(rect.startX, rect.startY, rect.w, rect.h);
    }
}
//
init();
document.getElementById('area').addEventListener('click', (el) => {
  console.log(el);
});

}
