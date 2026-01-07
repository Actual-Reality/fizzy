import { BridgeComponent } from "@hotwired/hotwire-native-bridge"
import { BridgeElement } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "form"
  static targets = [ "submit" ]
  static values = { submitTitle: String }

  connect() {
    super.connect()
    if (!this.hasSubmitTarget) return
    this.notifyBridgeOfConnect()
    this.observeSubmitTarget()
  }

  disconnect() {
    super.disconnect()
    this.submitObserver?.disconnect()
  }

  notifyBridgeOfConnect() {
    const submitButton = new BridgeElement(this.submitTarget)
    const title = submitButton.title
    const displaysNavButtonMenu = submitButton.displaysNavButtonMenu()

    this.send("connect", { title, displaysNavButtonMenu }, () => {
      this.submitTarget.click()
    })
  }

  observeSubmitTarget() {
    this.submitObserver = new MutationObserver(() => {
      this.send(this.submitTarget.disabled ? "submitDisabled" : "submitEnabled")
    })

    this.submitObserver.observe(this.submitTarget, {
      attributes: true,
      attributeFilter: [ "disabled" ]
    })
  }

  submitStart() {
    this.send("submitStart")
  }

  submitEnd() {
    this.send("submitEnd")
  }
}
