import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  sent(){

  fetch(
    this.element.dataset.markUrl,
    {
      method:"PATCH",
      headers:{
        "X-CSRF-Token":
        document.querySelector(
          "[name='csrf-token']"
        ).content
      }
    }
  )
  }
}