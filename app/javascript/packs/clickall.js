function clickAll() {
        console.log('hello');
        let forms = document.querySelectorAll('.corrected .simple_form');
        const requests = [];
        forms.forEach(function(form) {
          const promise = new Promise(function(resolve, reject) {
            form.addEventListener("ajax:success", () => {
              console.log(form.id);
              resolve();
            });
          });
          requests.push(promise);

          form.dispatchEvent(new Event('submit', {bubbles: true}));
        });
        // setTimeout(location.reload(), 1000)

        Promise.all(requests).then(() => {
          console.log("all done");
          location.reload();
        })
      }

      export { clickAll }
