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
