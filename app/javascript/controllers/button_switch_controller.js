import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="button-switch"
export default class extends Controller {
  connect() {

    console.log("hello")

    const formInputText = document.querySelector("#thought_content")
    const text = formInputText.value

    const saveBtn = document.querySelector("#save-button")
    const saveConnectBtn = document.querySelector("#save-connect-button")

    formInputText.addEventListener("keyup", () => {
      if (text !== formInputText.value) {
        saveBtn.classList.add("save-button")
        saveConnectBtn.classList.add("save-button")
      } else {
        saveBtn.classList.remove("save-button")
        saveConnectBtn.classList.remove("save-button")
      }
      // console.log(formInputText.value)
      // console.log(text)
    })


  }
}
