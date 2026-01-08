import { BridgeElement } from "@hotwired/hotwire-native-bridge"

BridgeElement.prototype.isDisplayedOnPlatform = function() {
  return !this.hasClass("hide-on-native")
}

BridgeElement.prototype.showOnPlatform = function() {
  this.element.classList.remove("hide-on-native")
}

BridgeElement.prototype.hideOnPlatform = function() {
  this.element.classList.add("hide-on-native")
}

BridgeElement.prototype.getButton = function() {
  return {
    title: this.title,
    icon: this.getIcon()
  }
}

BridgeElement.prototype.getIcon = function() {
  const url = this.bridgeAttribute(`icon-url`)

  if (url) {
    return { url }
  }

  return null
}


BridgeElement.prototype.displaysNavButtonMenu = function() {
  return this.bridgeAttribute("displays-nav-button-menu") === "true"
}
