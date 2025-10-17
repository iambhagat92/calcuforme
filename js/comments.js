/* Enhanced localStorage-based comments with reply functionality */
function postComment() {
  const name = document.getElementById('commentName').value.trim();
  const text = document.getElementById('commentText').value.trim();
  
  if (!name || !text) {
    alert('Please enter both name and comment');
    return;
  }
  
  const comment = {
    id: Date.now() + Math.random().toString(36).substr(2, 9),
    name: name,
    text: text,
    date: new Date().toISOString(),
    replies: []
  };
  
  const key = 'comments_' + window.location.pathname;
  const comments = JSON.parse(localStorage.getItem(key) || '[]');
  comments.unshift(comment);
  localStorage.setItem(key, JSON.stringify(comments));
  
  document.getElementById('commentName').value = '';
  document.getElementById('commentText').value = '';
  
  loadComments();
}

function loadComments() {
  const key = 'comments_' + window.location.pathname;
  const comments = JSON.parse(localStorage.getItem(key) || '[]');
  const container = document.getElementById('commentsContainer');
  
  if (!container) return;
  
  if (comments.length === 0) {
    container.innerHTML = '<p class="text-muted">No comments yet. Be the first to comment!</p>';
    return;
  }
  
  container.innerHTML = comments.map(comment => createCommentHTML(comment)).join('');
}

function createCommentHTML(comment) {
  const date = new Date(comment.date).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  });
  
  const repliesHTML = comment.replies && comment.replies.length > 0 
    ? comment.replies.map(reply => createReplyHTML(reply)).join('')
    : '';
  
  return `
    <div class="comment-item" style="border: 1px solid #e5e7eb; border-radius: 8px; padding: 1rem; margin-bottom: 1rem;">
      <div style="display: flex; justify-content: space-between; align-items: start;">
        <div style="flex-grow: 1;">
          <strong style="color: #1f2937;">${escapeHTML(comment.name)}</strong>
          <span style="color: #6b7280; font-size: 0.875rem; margin-left: 0.5rem;">${date}</span>
        </div>
      </div>
      <p style="color: #4b5563; margin: 0.5rem 0; white-space: pre-wrap;">${escapeHTML(comment.text)}</p>
      
      <div style="margin-top: 0.75rem;">
        <button onclick="toggleReplyForm('${comment.id}')" style="color: #3b82f6; background: none; border: none; padding: 0; font-size: 0.875rem; cursor: pointer;">
          <i class="fas fa-reply"></i> Reply
        </button>
        
        <!-- Reply Form (hidden by default) -->
        <div id="replyForm_${comment.id}" style="display: none; margin-top: 1rem; padding-left: 1rem; border-left: 2px solid #e5e7eb;">
          <input type="text" id="replyName_${comment.id}" placeholder="Your name" style="width: 100%; padding: 0.5rem; margin-bottom: 0.5rem; border: 1px solid #d1d5db; border-radius: 4px;">
          <textarea id="replyText_${comment.id}" placeholder="Write a reply..." rows="2" style="width: 100%; padding: 0.5rem; margin-bottom: 0.5rem; border: 1px solid #d1d5db; border-radius: 4px;"></textarea>
          <button onclick="postReply('${comment.id}')" style="background: #3b82f6; color: white; border: none; padding: 0.5rem 1rem; border-radius: 4px; cursor: pointer;">Post Reply</button>
          <button onclick="toggleReplyForm('${comment.id}')" style="background: #6b7280; color: white; border: none; padding: 0.5rem 1rem; border-radius: 4px; cursor: pointer; margin-left: 0.5rem;">Cancel</button>
        </div>
      </div>
      
      <!-- Replies -->
      ${repliesHTML ? `<div style="margin-top: 1rem; padding-left: 1rem; border-left: 2px solid #e5e7eb;">${repliesHTML}</div>` : ''}
    </div>
  `;
}

function createReplyHTML(reply) {
  const date = new Date(reply.date).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  });
  
  return `
    <div style="background: #f9fafb; border-radius: 6px; padding: 0.75rem; margin-top: 0.5rem;">
      <div>
        <strong style="color: #1f2937; font-size: 0.875rem;">${escapeHTML(reply.name)}</strong>
        <span style="color: #6b7280; font-size: 0.75rem; margin-left: 0.5rem;">${date}</span>
      </div>
      <p style="color: #4b5563; margin: 0.25rem 0; font-size: 0.875rem; white-space: pre-wrap;">${escapeHTML(reply.text)}</p>
    </div>
  `;
}

function toggleReplyForm(commentId) {
  const replyForm = document.getElementById('replyForm_' + commentId);
  if (replyForm) {
    replyForm.style.display = replyForm.style.display === 'none' ? 'block' : 'none';
  }
}

function postReply(commentId) {
  const name = document.getElementById('replyName_' + commentId).value.trim();
  const text = document.getElementById('replyText_' + commentId).value.trim();
  
  if (!name || !text) {
    alert('Please enter both name and reply');
    return;
  }
  
  const reply = {
    id: Date.now() + Math.random().toString(36).substr(2, 9),
    name: name,
    text: text,
    date: new Date().toISOString()
  };
  
  const key = 'comments_' + window.location.pathname;
  const comments = JSON.parse(localStorage.getItem(key) || '[]');
  
  const commentIndex = comments.findIndex(c => c.id === commentId);
  if (commentIndex !== -1) {
    if (!comments[commentIndex].replies) {
      comments[commentIndex].replies = [];
    }
    comments[commentIndex].replies.push(reply);
    localStorage.setItem(key, JSON.stringify(comments));
  }
  
  loadComments();
}

function escapeHTML(str) {
  const div = document.createElement('div');
  div.textContent = str;
  return div.innerHTML;
}

// Auto-load comments when page loads
if (typeof document !== 'undefined') {
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', loadComments);
  } else {
    loadComments();
  }
}
