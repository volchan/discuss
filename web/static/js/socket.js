import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

let channel = socket.channel("comments:4", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

document.getElementById("ping").addEventListener("click", (event) => {
  channel.push("comment:hello", {hi: "there"});
});

export default socket
