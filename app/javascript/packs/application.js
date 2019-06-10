import {move} from './progress.js'
import {clickAll} from './clickall.js'

import "bootstrap";
import "./upload_button";
import "./canvas";
import "./upload";
import "./selectall";
import "./progress";

// window.move = move;
document.getElementById("myProgress").addEventListener("click", () =>{
  clickAll();
  move();
})
