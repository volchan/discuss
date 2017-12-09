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

  channel.on(`comments:${topicId}:new`, renderComment)

  document.getElementById("comment-btn").addEventListener("click", (event) => {
    const textField = document.getElementById("comment-content");
    const content = textField.value;
    channel.push("comment:add", {content: content})
    textField.value = "";
  });
};

const renderComments = (comments) => {
  const renderedComments = comments.map(comment => {
    return commentTemplate(comment);
  });

  document.getElementById("comments-container").innerHTML = renderedComments.join("");
};

const renderComment = (event) => {
  const renderedComment = commentTemplate(event.comment);
  document.getElementById("comments-container").innerHTML += renderedComment;
};

const commentTemplate = (comment) => {
  let username = 'Anonymous';
  let avatar = 'https://cdn.kastatic.org/images/avatars/svg/orange-juice-squid.svg'
  if (comment.user) {
    username = comment.user.username
    if (comment.user.avatar) {
      avatar = comment.user.avatar
    }
  }
  return `
    <li class="collection-item">
      ${comment.content}
      <div class="secondary-content">
        <img src="${avatar}" style="width: 20px; border-radius: 4px">
        ${username}
      </div>
    </li>
  `
};

window.createSocket = createSocket;
