// app/javascript/application.js
import "@hotwired/turbo-rails"
import "controllers"
// import "custom"

import Alpine from "alpinejs"
import persist from "@alpinejs/persist"
import collapse from "@alpinejs/collapse"

window.Alpine = Alpine

Alpine.plugin(persist)
Alpine.plugin(collapse)

import "custom"

Alpine.start()