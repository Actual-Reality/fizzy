let top = 0

export const viewport = {
  get top() {
    return top
  },
  get height() {
    return visualViewport.height
  }
}

function update() {
  requestAnimationFrame(() => {
    top = parseInt(getComputedStyle(document.documentElement).getPropertyValue("--safe-area-inset-top"))
  })
}

visualViewport.addEventListener("resize", update)
update()
