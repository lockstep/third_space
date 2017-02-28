function openTip() {
  document.getElementById("tipOverlay").style.height = "100%";
  stopShakingTip(isTipClicked == undefined);
  localStorage.setItem("isTipClicked", true);
}

function closeTip() {
  document.getElementById("tipOverlay").style.height = "0%";
}
