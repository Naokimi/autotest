
const upload = document.getElementById("upload");

if (upload) {
  const submit = document.getElementById("submit");
  const body = document.querySelector("body");
  upload.addEventListener("change", (event) => {
    submit.click();
    console.log("display loading...");
    body.insertAdjacentHTML('afterbegin', "<div style='position: fixed; z-index:1; width:100%; height:100%; text-align:center; background-color: rgba(255, 255, 255, 0.7)'><%= image_tag 'Spinner-1.4s-200px.gif', class:'mt-5 pt-5' %><h2 class='mt-5 text-primary'>Uploading images...please wait</h2></div>");
  });
}
