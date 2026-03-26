import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    // editor_controller.js
connect() {
  console.log("EDITOR CONNECTED", this.element)
}
  saveText(event) {
    const blockId = event.target.dataset.blockId
    const content = event.target.innerHTML

    fetch(`/brochure_blocks/${blockId}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content
      },
      body: JSON.stringify({ content })
    })
  }

  uploadImage(event) {
    const blockId = event.target.dataset.blockId
    const file = event.target.files[0]

    const formData = new FormData()
    formData.append("image", file)

    fetch(`/brochure_blocks/${blockId}/image`, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content
      },
      body: formData
    })
  }

}
