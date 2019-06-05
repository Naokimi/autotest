
const upload = document.getElementById("upload");

if (upload) {
  const submit = document.getElementById("submit");
  upload.addEventListener("change", (event) => {
    submit.click();
  });
}
