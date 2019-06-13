
const upload = document.getElementById("upload");

if (upload) {
  const submit = document.getElementById("submit");
  const body = document.querySelector("body");
  upload.addEventListener("change", (event) => {
    submit.click();
    console.log("display loading...");
    body.insertAdjacentHTML('afterbegin', "<div class='uploading'><h2 class='text-primary'>Uploading images...</h2></div>");
  });
}
