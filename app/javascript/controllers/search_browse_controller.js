import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-browse"
export default class extends Controller {
  static targets = ["browseForm", "browseInput", "browseList"]

  connect() {
    console.log(this.browseFormTarget)
  }

  update() {
    console.log("check!")
    const url = `${this.browseFormTarget.action}?query=${this.browseInputTarget.value}`

    console.log(`${this.browseFormTarget}`);
    console.log(`${this.browseFormTarget.action}`);
    console.log(url)

    fetch(url, {headers: {"Accept": "text/plain"}})
      .then(response => response.text())
      .then((data) => {
        this.browseListTarget.outerHTML = data
      })
  }
}
