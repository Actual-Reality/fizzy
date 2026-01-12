import { Controller } from "@hotwired/stimulus"
import { isTouchDevice } from "helpers/platform_helpers"

export default class extends Controller {
  static targets = [ "mouse", "touch" ]

  connect() {
    this.#setup()
  }

  #setup() {
    const touch = isTouchDevice()
    if (this.hasMouseTarget) this.mouseTarget.autofocus = !touch
    if (this.hasTouchTarget) this.touchTarget.autofocus = touch
  }
}
