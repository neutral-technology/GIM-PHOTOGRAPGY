//app/javascript/controllers/application.js
import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
// import Rails from "@rails/ujs"

const application = Application.start()

// Rails.start() // ✅ This is where UJS gets started

application.debug = false
window.Stimulus = application

export { application };
