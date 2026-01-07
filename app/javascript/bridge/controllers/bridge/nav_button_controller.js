import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "nav-button"

  connect() {
    super.connect()

    if (this.bridgeElement.enabled) {
      this.notifyBridgeOfConnect()
    }
  }

  notifyBridgeOfConnect() {
    const navButton = this.bridgeElement.getButton()
    navButton.displayAsFormSubmitMenu = this.bridgeElement.shouldDisplayAsFormSubmitMenu()

    this.send("connect", navButton, () => {
      this.element.click()
    })
  }
}
