import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="stories-list-item"
export default class extends Controller {
  static targets = ["menu"];

  toggle() {
    if (this.menuTarget.classList.contains("hidden")) {
      this.menuTarget.classList.remove(
        "hidden",
        "transform",
        "opacity-0",
        "scale-95"
      );
      this.menuTarget.classList.add(
        "transition",
        "ease-out",
        "duration-100",
        "transform",
        "opacity-100",
        "scale-100"
      );
    } else {
      this.menuTarget.classList.remove("transform", "opacity-100", "scale-100");
      this.menuTarget.classList.add(
        "transition",
        "ease-in",
        "duration-75",
        "transform",
        "opacity-0",
        "scale-95"
      );
      setTimeout(() => {
        this.menuTarget.classList.add("hidden");
      }, 75); // Match the duration-75 class
    }
  }

  connect() {
    document.addEventListener("click", this.handleClickOutside.bind(this));
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside.bind(this));
  }

  handleClickOutside(event) {
    if (
      !this.element.contains(event.target) &&
      !this.menuTarget.classList.contains("hidden")
    ) {
      this.menuTarget.classList.remove("transform", "opacity-100", "scale-100");
      this.menuTarget.classList.add(
        "transition",
        "ease-in",
        "duration-75",
        "transform",
        "opacity-0",
        "scale-95"
      );
      setTimeout(() => {
        this.menuTarget.classList.add("hidden");
      }, 75); // Match the duration-75 class
    }
  }
}
