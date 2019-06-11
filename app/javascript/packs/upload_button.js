
const upload = document.getElementById("upload");

if (upload) {
  const submit = document.getElementById("submit");
  upload.addEventListener("change", (event) => {
    console.log("display loading...");
    submit.click();
  });
}
