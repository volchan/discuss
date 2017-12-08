import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

const createSocket = (topicId) => {
  let channel = socket.channel(`comments:${topicId}`, {})
  channel.join()
  .receive("ok", resp => {
    renderComments(resp.comments);
  })
  .receive("error", resp => {
    console.log("Unable to join", resp)
  })

  channel.on(`comments:${topicId}:new`, renderComent)

  document.getElementById("comment-btn").addEventListener("click", (event) => {
    const content = document.getElementById("comment-content").value;
    channel.push("comment:add", {content: content})
  });
};

const renderComments = (comments) => {
  const renderedComments = comments.map(comment => {
    return commentTemplate(comment);
  });

  document.getElementById("comments-container").innerHTML = renderedComments.join("");
};

const renderComent = (event) => {
  const renderedComment = commentTemplate(event.comment);

  document.getElementById("comments-container").innerHTML += renderedComment;
};

const commentTemplate = (comment) => {
  return `<li class="collection-item">${comment.content}</li>`
};

window.createSocket = createSocket;
