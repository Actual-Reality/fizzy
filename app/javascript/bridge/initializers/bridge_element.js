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
    icon: this.getIcon(),
    label: this.getLabel(),
    order: this.getOrder()
  }
}

BridgeElement.prototype.getIcon = function() {
  const name = this.bridgeAttribute("icon-name")
  const url = this.bridgeAttribute(`icon-${this.platform}-url`)

  if (name || url) {
    return { name, url }
  }

  return null
}

BridgeElement.prototype.getLabel = function() {
  return this.bridgeAttribute("label")
}

BridgeElement.prototype.getOrder = function() {
  return this.bridgeAttribute("order") || "1"
}

BridgeElement.prototype.shouldDisplayAsFormSubmitMenu = function() {
  return this.bridgeAttribute("display-as-form-submit-menu") === "true"
}

BridgeElement.prototype.displaysNavButtonMenu = function() {
  return this.bridgeAttribute("displays-nav-button-menu") === "true"
}
