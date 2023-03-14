import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["form", "inputThought", "listThought"]

  connect() {
    console.log(this.formTarget)
  }

  update() {
    console.log("checked!")
    const url = `${this.formTarget.action}?query=${this.inputThoughtTarget.value}`
    fetch(url, {headers: {"Accept": "text/plain"}})
      .then(response => response.text())
      .then((data) => {
        this.listThoughtTarget.outerHTML = data
      })
  }
}
