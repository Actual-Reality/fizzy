import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { startTime: String }
  static targets = ["output"]

  connect() {
    this.refresh()
    this.timer = setInterval(() => this.refresh(), 1000)
  }

  disconnect() {
    clearInterval(this.timer)
  }

  refresh() {
    const start = new Date(this.startTimeValue).getTime()
    const now = new Date().getTime()
    const diff = Math.floor((now - start) / 1000)

    if (diff < 0) return

    const hours = Math.floor(diff / 3600)
    const mins = Math.floor((diff % 3600) / 60)
    const secs = diff % 60

    let output = ""
    if (hours > 0) output += `${hours}h `
    output += `${mins}m ${secs}s`

    this.outputTarget.textContent = output
  }
}
