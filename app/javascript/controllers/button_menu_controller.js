import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  toggle() {
    this.element.classList.toggle("menu-open");
  }

  connect() {
    document.addEventListener("click", this.handleClickOutside.bind(this));
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside.bind(this));
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.element.classList.remove("menu-open");
    }
  }
}
