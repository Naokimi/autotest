import {move} from './progress.js'
import {clickAll} from './clickall.js'

import "bootstrap";
import "./upload_button";
import "./canvas";
import "./upload";
import "./selectall";
import "./progress";

// window.move = move;
let progress = document.getElementById("myProgress");

  progress.addEventListener("click", () =>{
    clickAll();
    move();
  })

