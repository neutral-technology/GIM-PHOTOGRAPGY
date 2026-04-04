// /Users/topazjos/Documents/neutral/projects/GIM-PHOTOGRAPGY/app/javascript/controllers/client_search_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "hidden", "results"]
  static values = { clients: Array } // 🔥 THIS LINE

  connect() {
    console.log("🔥 ClientSearch connected")
    this.clients = this.clientsValue || []
  }

  search() {
    if (!this.clients) return
    const query = this.inputTarget.value.toLowerCase()

    if (query.length < 1) {
      this.resultsTarget.innerHTML = ""
      this.resultsTarget.classList.add("hidden")
      return
    }

    const matches = this.clients.filter(client =>
      client.name.toLowerCase().includes(query) ||
      client.tel.includes(query)
    )

    this.renderResults(matches)
  }

  renderResults(clients) {
    this.resultsTarget.innerHTML = ""

    if (clients.length === 0) {
      this.resultsTarget.classList.add("hidden")
      return
    }

    clients.slice(0, 10).forEach(client => {
      const div = document.createElement("div")
      div.className = "p-2 hover:bg-gray-100 cursor-pointer border-b"
      div.innerText = `${client.tel} - ${client.name}`

      div.addEventListener("click", () => {
        this.selectClient(client)
      })

      this.resultsTarget.appendChild(div)
    })

    this.resultsTarget.classList.remove("hidden")
  }

  selectClient(client) {
    this.inputTarget.value = `${client.tel} - ${client.name}`
    this.hiddenTarget.value = client.id
    this.resultsTarget.innerHTML = ""
    this.resultsTarget.classList.add("hidden")
  }
}