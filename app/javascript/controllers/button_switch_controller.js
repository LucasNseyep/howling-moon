import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="button-switch"
export default class extends Controller {
  connect() {

    const formInputText = document.querySelector("#thought_content")

    const saveBtn = document.querySelector("#save-button")
    const saveConnectBtn = document.querySelector("#save-connect-button")

    formInputText.addEventListener("keydown", () => {
      if (formInputText.value) {
        saveBtn.classList.add("save-button")
        saveConnectBtn.classList.add("save-button")
      } else {
        saveBtn.classList.remove("save-button")
        saveConnectBtn.classList.remove("save-button")
      }
    })
  }
}
