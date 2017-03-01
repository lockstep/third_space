function openTip(id) {
  document.getElementById(id).style.height = "100%";
  if(id === "tipOverlay") {
    stopShakingTip(isTipClicked == undefined);
    localStorage.setItem("isTipClicked", true);
  }
}

function closeTip(id) {
  document.getElementById(id).style.height = "0%";
}
