import {move} from './progress.js'
import {clickAll} from './clickall.js'
import {initStepper} from '../plugins/init_stepper.js'

import "bootstrap";
import "./upload_button";
import { initCanvas } from "./canvas";
import "./upload";
import "./selectall";
import "./progress";
import "./loader"
initCanvas("canvas");
initStepper();
// window.move = move;
let progress = document.getElementById("myProgress");
if (progress) {
  progress.addEventListener("click", () =>{
    clickAll();
    move();
  })
}




