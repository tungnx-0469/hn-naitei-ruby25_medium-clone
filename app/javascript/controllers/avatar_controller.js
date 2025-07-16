import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "preview" ]

  preview() {
    let file = this.inputTarget.files[0]
    if (file) {
      let reader = new FileReader()
      reader.onloadend = () => {
        this.previewTarget.src = reader.result
      }
      reader.readAsDataURL(file)
    }
  }
}
