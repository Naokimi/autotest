function clickAll() {
  let forms = document.querySelectorAll('.simple_form');
  const requests = [];
  forms.forEach(function(form) {
    const promise = new Promise(function(resolve, reject) {
      form.addEventListener("ajax:success", () => {
        resolve();
      });
    });
    requests.push(promise);

    form.dispatchEvent(new Event('submit', {bubbles: true}));
  });

  Promise.all(requests).then(() => {
    location.reload();
  })
}

export { clickAll }
