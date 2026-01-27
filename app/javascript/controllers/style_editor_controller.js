import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["primary", "bg", "font", "text"]
  static values = { id: Number }

  update() {
    // Select the wrapper that holds our CSS variables
    const editor = document.querySelector('.brochure-editor')
    
    // Update variables in real-time
    editor.style.setProperty('--primary', this.primaryTarget.value)
    editor.style.setProperty('--bg', this.bgTarget.value)
    editor.style.setProperty('--text', this.textTarget.value)
    
    // Update the font family variable
    if (this.hasFontTarget) {
      editor.style.setProperty('--font-main', this.fontTarget.value)
    }
  }

  async save() {
    const overrides = {
      colors: {
        primary: this.primaryTarget.value,
        background: this.bgTarget.value,
        text: this.textTarget.value
      },
      fonts: {
        main: this.hasFontTarget ? this.fontTarget.value : 'Nunito'
      }
    }

    const response = await fetch(`/brochures/${this.idValue}/update_theme`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ overrides })
    })

    if (response.ok) {
      alert("Theme saved successfully!")
    }
  }
}