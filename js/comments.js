/* Simple localStorage-based comments (no login, device-only)
   Adds comments to the section#comments-section on blog pages. */
(function () {
  function qs(sel, root) { return (root || document).querySelector(sel); }
  function qsa(sel, root) { return Array.from((root || document).querySelectorAll(sel)); }
  function escapeHTML(s) {
    return s.replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
  }
  function fmtDate(ts){
    try { return new Date(ts).toLocaleString(); } catch(e){ return ''+ts; }
  }

  const section = qs('#comments-section') || qs('section.comments');
  if (!section) return;

  const key = 'cfm_comments::' + location.pathname;
  const listEl = qs('#comments-list', section) || (function(){
    const div = document.createElement('div');
    div.id = 'comments-list';
    section.appendChild(div);
    return div;
  })();
  const form = qs('#comment-form', section);
  const nameEl = qs('#comment-name', section) || (function(){
    const i = document.createElement('input');
    i.type='text'; i.id='comment-name'; i.placeholder='Your name'; i.required=true;
    form && form.insertBefore(i, form.firstChild);
    return i;
  })();
  const msgEl = qs('#comment-message', section) || (function(){
    const t = document.createElement('textarea');
    t.id='comment-message'; t.rows=3; t.placeholder='Write a comment...'; t.required=true;
    form && form.appendChild(t);
    return t;
  })();

  function load(){
    try { return JSON.parse(localStorage.getItem(key) || '[]'); } catch(e){ return []; }
  }
  function save(arr){ localStorage.setItem(key, JSON.stringify(arr)); }

  function render(){
    const data = load();
    if (!data.length) {
      listEl.innerHTML = '<p style="color:#64748b;">No comments yet. Be the first to comment!</p>';
      return;
    }
    listEl.innerHTML = data.map(c => (
      '<div style="border:1px solid #e5e7eb; border-radius:8px; padding:0.75rem; margin:0.5rem 0;">'
      + '<div style="font-weight:600; color:#334155;">' + escapeHTML(c.name || 'Anonymous') + '</div>'
      + '<div style="white-space:pre-wrap; color:#475569; margin-top:0.25rem;">' + escapeHTML(c.msg || '') + '</div>'
      + '<div style="color:#94a3b8; font-size:0.8rem; margin-top:0.25rem;">' + fmtDate(c.ts) + '</div>'
      + '</div>'
    )).join('');
  }

  if (form) {
    form.addEventListener('submit', function(e){
      e.preventDefault();
      const name = (nameEl.value || 'Anonymous').trim();
      const msg = (msgEl.value || '').trim();
      if (!msg) return;
      const data = load();
      data.push({ id: Date.now() + ':' + Math.random().toString(36).slice(2), name, msg, ts: Date.now() });
      save(data);
      msgEl.value = '';
      render();
    });
  }

  render();
})();
