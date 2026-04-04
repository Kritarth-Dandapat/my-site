/**
 * When served from localhost, rewrite cross-site links to local preview ports.
 * Ports file is written by scripts/serve-all.sh (local-preview-ports.json).
 */
(function () {
  var h = location.hostname;
  if (h !== 'localhost' && h !== '127.0.0.1') return;

  function defaults() {
    return { hub: 8081, notebook: 8082, portfolio: 3000 };
  }

  function portsJsonUrl() {
    return /\/configs\//.test(location.pathname) ? '../local-preview-ports.json' : 'local-preview-ports.json';
  }

  function apply(ports) {
    var hubBase = 'http://127.0.0.1:' + ports.hub;
    var pf = 'http://127.0.0.1:' + ports.portfolio + '/';
    var nb = 'http://127.0.0.1:' + ports.notebook + '/';
    var rules = [
      [/^https:\/\/portfolio\.dkritarth\.com\/?$/i, pf],
      [/^https:\/\/notebook\.dkritarth\.com\/?$/i, nb],
      [/^https:\/\/dkritarth\.com\/configs\/?$/i, hubBase + '/configs/'],
      [/^https:\/\/dkritarth\.com\/?$/i, hubBase + '/'],
    ];

    document.querySelectorAll('a[href]').forEach(function (a) {
      var href = a.getAttribute('href');
      if (!href || href.indexOf('mailto:') === 0) return;
      for (var i = 0; i < rules.length; i++) {
        var re = rules[i][0];
        var to = rules[i][1];
        if (re.test(href)) {
          a.setAttribute('href', href.replace(re, to));
          return;
        }
      }
    });

    document.querySelectorAll('.card-meta').forEach(function (el) {
      var t = el.textContent || '';
      if (t.indexOf('portfolio.dkritarth.com') !== -1) el.textContent = '127.0.0.1:' + ports.portfolio;
      else if (t.indexOf('notebook.dkritarth.com') !== -1) el.textContent = '127.0.0.1:' + ports.notebook;
      else if (t.indexOf('dkritarth.com/configs') !== -1) el.textContent = '127.0.0.1:' + ports.hub + '/configs';
    });
  }

  function run() {
    fetch(portsJsonUrl(), { cache: 'no-store' })
      .then(function (r) {
        return r.ok ? r.json() : defaults();
      })
      .then(function (p) {
        apply({
          hub: Number(p.hub) || defaults().hub,
          notebook: Number(p.notebook) || defaults().notebook,
          portfolio: Number(p.portfolio) || defaults().portfolio,
        });
      })
      .catch(function () {
        apply(defaults());
      });
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', run);
  else run();
})();
