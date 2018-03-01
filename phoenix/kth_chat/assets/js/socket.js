import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}});

let list = document.getElementById('msg-list')
let name = document.getElementById('name')
let message = document.getElementById('msg')

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("room:lobby", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })


// Allow users to send messages
message.addEventListener('keypress', function(event){
  if(event.keyCode == 13 && message.value.length > 0){
      channel.push('shout', {
        name: name.value,
        message: message.value
      })
      message.value = '';
  }
})

// Receive messages from users
channel.on('shout', function(payload) {
    let li = document.createElement("li")
    let name = payload.name || 'guest'
    li.innerHTML = '<b>' + name + '</b>: ' + payload.message;
    list.appendChild(li);
})

export default socket
