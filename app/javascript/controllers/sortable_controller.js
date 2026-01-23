// app/javascript/controllers/sortable_controller.js
import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  connect() {
    if (typeof Sortable === 'undefined') {
        console.error("Sortable is still not defined!");
        return;
    }

    console.log("✅ SORTABLE CONNECTED")

    this.sortable = new Sortable(this.element, {
      animation: 150,
      ghostClass: "blue-ghost-class",
      dragClass: "dragging-item-class",
      forceFallback: true,
      handle: ".block", // Specifically target the block as the handle
      onEnd: (e) => this.reorder(e)
    })
  }

  reorder(event) {
    const blockId = event.item.dataset.blockId
    const position = event.newIndex + 1

    fetch(`/brochure_blocks/${blockId}/reorder`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content
      },
      body: JSON.stringify({ position })
    })
  }
}
