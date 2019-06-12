import Stepper from 'bs-stepper';
import { initCanvas } from "../packs/canvas";

const initStepper = () => {
  document.addEventListener('DOMContentLoaded', function () {
    const stepperElement = document.querySelector('.bs-stepper');
    if (stepperElement) {
      var stepper = new Stepper(stepperElement);

      stepperElement.addEventListener('shown.bs-stepper', (event) => {
        initCanvas("canvas2");
      });

      const btn = document.getElementById('next');
      if (btn) {
        btn.addEventListener('click', () => {
          stepper.next();
        });
      }

      const btnNewQ = document.getElementById('btnAll');
      if (btnNewQ) {
        btnNewQ.addEventListener('click', () => {
          stepper.next();
        });
      }
    }
  });
};

export { initStepper };
