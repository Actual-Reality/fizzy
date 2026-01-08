import { BridgeComponent } from "@hotwired/hotwire-native-bridge"
import { BridgeElement } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "overflow-menu"
  static targets = [ "item" ]

  connect() {
    super.connect()
    if (!this.hasItemTarget) return
    this.notifyBridgeOfConnect()
  }

  disconnect() {
    super.disconnect()
    this.notifyBridgeOfDisconnect()
  }

  notifyBridgeOfConnect() {
    const items = this.itemTargets.map((target, index) => {
      const element = new BridgeElement(target)
      return { title: element.title, index }
    })

    this.send("connect", { items }, message => {
      this.activateItem(message)
    })
  }

  notifyBridgeOfDisconnect() {
    this.send("disconnect")
  }

  activateItem(message) {
    const selectedIndex = message.data.selectedIndex
    this.itemTargets[selectedIndex].click()
  }
}
