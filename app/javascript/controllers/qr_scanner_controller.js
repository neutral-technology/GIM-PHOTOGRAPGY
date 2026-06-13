import { Controller } from "@hotwired/stimulus"
import QrScanner from "qr-scanner"

export default class extends Controller {

  static targets = [
    "modal",
    "video"
  ]

  connect() {
    this.scanner = null
  }

  open(){
    this.modalTarget.classList.remove("hidden")
    this.modalTarget.classList.add("flex")
    this.startScanner()
  }

  startScanner(){
    this.scanner = new QrScanner(
      this.videoTarget,
      result => {
        const token = result.data.split("/").pop()
        fetch(
          `/client/checkin/${token}`,
          {
            method:"POST",
            headers:{
              "X-CSRF-Token":
              document.querySelector(
                "[name='csrf-token']"
              ).content
            }
          }
        )
        .then(r=>r.json())
        .then(data=>{
          alert(
            `✅ ${data.name} - Table ${data.table}`
          )
          this.close()
          window.location.reload()
        })
      },
      {
        highlightScanRegion:true,
        highlightCodeOutline:true
      }
    )
    this.scanner.start()
  }

  close(){
    if(this.scanner){
      this.scanner.stop()
      this.scanner.destroy()
      this.scanner = null
    }
    this.modalTarget.classList.add("hidden")
    this.modalTarget.classList.remove("flex")
  }

  disconnect(){
    this.close()
  }
}