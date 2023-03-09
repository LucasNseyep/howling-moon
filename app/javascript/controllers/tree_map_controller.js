import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tree-map"
export default class extends Controller {
  connect() {
    console.log("Hi from tree-map-controller")
  }
}
