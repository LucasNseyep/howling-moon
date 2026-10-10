import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-browse"
export default class extends Controller {
  static targets = ["browseForm", "browseInput", "browseList"]

  update() {
    const url = `${this.browseFormTarget.action}?query=${this.browseInputTarget.value}`
    fetch(url, {headers: {"Accept": "text/plain"}})
      .then(response => response.text())
      .then((data) => {
        this.browseListTarget.outerHTML = data
      })
  }
}
