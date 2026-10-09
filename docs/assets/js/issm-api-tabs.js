// Builds MATLAB/Python tabs for every <div class="issm-api-tabs"> on the page.
// The div just contains a ```mat block and a ```py block; see tutorials/squareiceshelf.md.
(function () {
  var LABELS = { mat: 'MATLAB', py: 'Python' };
  var KEY = 'issm-api';

  function show(api) {
    document.querySelectorAll('.issm-api-tabs').forEach(function (box) {
      box.querySelectorAll('[data-api]').forEach(function (el) {
        el.classList.toggle('active', el.dataset.api === api);
      });
    });
    try { localStorage.setItem(KEY, api); } catch (e) {}
  }

  function init() {
    var saved = null;
    try { saved = localStorage.getItem(KEY); } catch (e) {}

    document.querySelectorAll('.issm-api-tabs').forEach(function (box) {
      var bar = document.createElement('div');
      bar.className = 'tab-bar';
      Array.prototype.slice.call(box.children).forEach(function (panel) {
        // Rouge wraps known languages in div.language-X, but an unknown one
        // (mat) is a bare <pre><code class="language-X">, so check both.
        var api = Object.keys(LABELS).filter(function (k) {
          return panel.classList.contains('language-' + k) ||
                 panel.querySelector('code.language-' + k);
        })[0];
        if (!api) return;
        panel.dataset.api = api;
        var b = document.createElement('button');
        b.type = 'button';
        b.dataset.api = api;
        b.textContent = LABELS[api];
        b.addEventListener('click', function () { show(api); });
        bar.appendChild(b);
      });
      box.insertBefore(bar, box.firstChild);
    });
    show(saved in LABELS ? saved : 'mat');
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
  else init();
})();
