import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  submit(event){

    event.preventDefault()
    let form = event.target

    let data = {
      name: form.guest_name.value,
      attendance: form.attendance.value,
      message: form.message.value
    }
    fetch("/rsvp",
    {
      method:"POST",
      headers:{
        "Content-Type":"application/json",
        "X-CSRF-Token":
          document.querySelector('meta[name="csrf-token"]').content
      },

      body: JSON.stringify(data)

    })
    .then(()=>{
        alert("Merci pour votre réponse ❤️")
        form.reset()
    })
  }
}