import Stepper from 'bs-stepper';
import { initCanvas } from "../packs/canvas";

const initStepper = () => {
  document.addEventListener('DOMContentLoaded', function () {
    const stepperElement = document.querySelector('.bs-stepper');
    if (stepperElement) {
      var stepper = new Stepper(stepperElement);
      console.log("pas");

      stepperElement.addEventListener('shown.bs-stepper', (event) => {
        initCanvas("canvas2");
      });

      const btn = document.getElementById('next');
      btn.addEventListener('click', () => {
        console.log("press");
        stepper.next();
      });
    }
  });
};

export { initStepper };
