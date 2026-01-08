import { BridgeComponent } from "@hotwired/hotwire-native-bridge"
import { BridgeElement } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "overflow-menu"
  static targets = [ "item" ]

  connect() {
    super.connect()

    if (this.hasItemTarget) {
      this.notifyBridgeOfConnect()
    }
  }

  disconnect() {
    super.disconnect()

    if (this.hasItemTarget) {
      this.notifyBridgeOfDisconnect()
    }
  }

  notifyBridgeOfConnect() {
    const items = this.itemTargets.map((target, index) => {
      const element = new BridgeElement(target)
      return { title: element.title, index }
    })

    this.send("connect", { items }, message => {
      this.clickItem(message)
    })
  }

  notifyBridgeOfDisconnect() {
    this.send("disconnect")
  }

  clickItem(message) {
    const selectedIndex = message.data.selectedIndex
    this.itemTargets[selectedIndex].click()
  }
}
