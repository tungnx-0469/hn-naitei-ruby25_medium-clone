import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["from", "to"]

  connect() {
    this.updateToMin()
    this.updateFromMax()
  }

  updateToMin() {
    if (this.hasFromTarget && this.hasToTarget) {
      this.toTarget.min = this.fromTarget.value
    }
  }

  updateFromMax() {
    if (this.hasFromTarget && this.hasToTarget) {
      this.fromTarget.max = this.toTarget.value
    }
  }
}
