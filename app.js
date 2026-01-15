const form = document.getElementById('search-form');
const input = document.getElementById('query');
const resultsEl = document.getElementById('results');
const emptyState = document.getElementById('empty-state');
const emptyTitle = document.getElementById('empty-title');
const emptyMessage = document.getElementById('empty-message');
const statusEl = document.getElementById('status');
const resultsCount = document.getElementById('results-count');
const offlineBanner = document.getElementById('offline-banner');
const openExternal = document.getElementById('open-external');
const luckyButton = document.getElementById('lucky-button');

const STORAGE_KEY = 'justgoogle:last-results';
let lastQuery = '';
let lastResults = [];

const setStatus = (message, tone) => {
  statusEl.textContent = message;
  if (tone) {
    statusEl.dataset.tone = tone;
  } else {
    delete statusEl.dataset.tone;
  }
};

const setResultsCount = (count) => {
  resultsCount.textContent = count ? `About ${count} results` : '0 results';
};

const setEmptyState = (title, message) => {
  emptyTitle.textContent = title;
  emptyMessage.textContent = message;
  emptyState.hidden = false;
};

const clearEmptyState = () => {
  emptyState.hidden = true;
};

const updateExternalLink = (query) => {
  const safeQuery = query ? encodeURIComponent(query) : '';
  openExternal.href = safeQuery ? `https://duckduckgo.com/?q=${safeQuery}` : 'https://duckduckgo.com';
};

const updateOnlineUI = () => {
  offlineBanner.hidden = navigator.onLine;
};

const flattenTopics = (topics, results) => {
  topics.forEach((topic) => {
    if (topic.Topics) {
      flattenTopics(topic.Topics, results);
    } else if (topic.FirstURL && topic.Text) {
      results.push(topic);
    }
  });
};

const parseResults = (data) => {
  const results = [];
  if (data.AbstractURL && data.AbstractText) {
    results.push({
      title: data.Heading || 'Instant Answer',
      snippet: data.AbstractText,
      url: data.AbstractURL,
    });
  }

  const topics = [];
  flattenTopics(data.RelatedTopics || [], topics);

  const seen = new Set();
  topics.forEach((topic) => {
    if (seen.has(topic.FirstURL)) {
      return;
    }
    seen.add(topic.FirstURL);
    const parts = topic.Text.split(' - ');
    const title = parts.shift() || topic.Text;
    const snippet = parts.join(' - ') || 'DuckDuckGo related topic';
    results.push({
      title,
      snippet,
      url: topic.FirstURL,
    });
  });

  return results;
};

const renderResults = (results) => {
  resultsEl.innerHTML = '';
  clearEmptyState();
  if (!results.length) {
    setResultsCount(0);
    setEmptyState('No matches found.', 'Try a broader query or open the full search page.');
    return;
  }

  results.forEach((result, index) => {
    const card = document.createElement('a');
    card.className = 'result-card';
    card.href = result.url;
    card.target = '_blank';
    card.rel = 'noopener';
    card.style.setProperty('--delay', `${Math.min(index * 60, 300)}ms`);

    const title = document.createElement('div');
    title.className = 'result-title';
    title.textContent = result.title;

    const snippet = document.createElement('div');
    snippet.className = 'result-snippet';
    snippet.textContent = result.snippet;

    const url = document.createElement('div');
    url.className = 'result-url';
    url.textContent = result.url;

    card.append(title, snippet, url);
    resultsEl.appendChild(card);
  });

  setResultsCount(results.length);
};

const updateResultsState = (query, results) => {
  lastQuery = query;
  lastResults = results;
  renderResults(results);
};

const saveResults = (query, results) => {
  const payload = {
    query,
    results,
    savedAt: Date.now(),
  };
  localStorage.setItem(STORAGE_KEY, JSON.stringify(payload));
};

const loadResults = () => {
  const raw = localStorage.getItem(STORAGE_KEY);
  if (!raw) {
    return null;
  }
  try {
    return JSON.parse(raw);
  } catch (error) {
    return null;
  }
};

const fetchDDG = (query) => {
  return new Promise((resolve, reject) => {
    const callbackName = `ddg_${Date.now()}_${Math.random().toString(36).slice(2)}`;
    const script = document.createElement('script');
    const timeout = setTimeout(() => {
      cleanup();
      reject(new Error('Request timed out'));
    }, 12000);

    const cleanup = () => {
      clearTimeout(timeout);
      delete window[callbackName];
      script.remove();
    };

    window[callbackName] = (data) => {
      cleanup();
      resolve(data);
    };

    script.src = `https://api.duckduckgo.com/?q=${encodeURIComponent(query)}&format=json&no_redirect=1&no_html=1&skip_disambig=1&callback=${callbackName}`;
    script.onerror = () => {
      cleanup();
      reject(new Error('Network error'));
    };

    document.body.appendChild(script);
  });
};

const isSafeUrl = (url) => {
  try {
    const parsed = new URL(url);
    return parsed.protocol === 'http:' || parsed.protocol === 'https:';
  } catch (error) {
    return false;
  }
};

const openFirstResult = (results) => {
  const first = results.find((result) => isSafeUrl(result.url));
  if (!first) {
    setStatus('No safe result to open.', 'error');
    return;
  }
  window.location.href = first.url;
};

const performSearch = async (query, options = {}) => {
  const { lucky = false } = options;
  const trimmed = query.trim();
  if (!trimmed) {
    setStatus('Enter a search term to begin.', 'error');
    return;
  }

  updateExternalLink(trimmed);
  setStatus('Searching...', '');
  resultsEl.innerHTML = '';
  setResultsCount(0);
  clearEmptyState();

  if (!navigator.onLine) {
    const cached = loadResults();
    if (cached && cached.query.toLowerCase() === trimmed.toLowerCase()) {
      updateResultsState(cached.query, cached.results);
      setStatus('Offline. Showing cached results.', 'success');
      if (lucky && cached.results.length) {
        openFirstResult(cached.results);
      } else if (lucky) {
        setStatus('No cached results to open.', 'error');
      }
    } else {
      setEmptyState('Offline right now.', 'Connect to the internet to fetch new results.');
      setStatus('No cached results for this query.', 'error');
    }
    return;
  }

  try {
    const data = await fetchDDG(trimmed);
    const results = parseResults(data);
    updateResultsState(trimmed, results);
    saveResults(trimmed, results);
    if (!results.length) {
      setStatus(`No results found for "${trimmed}".`, 'error');
    } else {
      setStatus(`Showing ${results.length} results for "${trimmed}".`, 'success');
    }
    if (lucky && results.length) {
      openFirstResult(results);
    } else if (lucky) {
      setStatus('No results to open.', 'error');
    }
  } catch (error) {
    const cached = loadResults();
    if (cached) {
      updateResultsState(cached.query, cached.results);
      setStatus('Network error. Showing cached results instead.', 'error');
      if (lucky && cached.results.length) {
        openFirstResult(cached.results);
      } else if (lucky) {
        setStatus('No cached results to open.', 'error');
      }
    } else {
      setEmptyState('Search failed.', 'Please try again in a moment.');
      setStatus('Search failed. Please try again.', 'error');
    }
  }
};

form.addEventListener('submit', (event) => {
  event.preventDefault();
  performSearch(input.value);
});

luckyButton.addEventListener('click', () => {
  const trimmed = input.value.trim();
  if (!trimmed) {
    setStatus('Enter a search term to begin.', 'error');
    return;
  }
  if (lastResults.length && lastQuery.toLowerCase() === trimmed.toLowerCase()) {
    openFirstResult(lastResults);
    return;
  }
  performSearch(trimmed, { lucky: true });
});

window.addEventListener('online', updateOnlineUI);
window.addEventListener('offline', updateOnlineUI);
updateOnlineUI();

const loadInitialState = () => {
  const params = new URLSearchParams(window.location.search);
  const query = params.get('q');
  if (query) {
    input.value = query;
    performSearch(query);
    return;
  }

  const cached = loadResults();
  if (cached) {
    input.value = cached.query;
    updateExternalLink(cached.query);
    updateResultsState(cached.query, cached.results);
    setStatus('Showing cached results from your last search.', 'success');
  }
};

const registerServiceWorker = () => {
  if ('serviceWorker' in navigator) {
    window.addEventListener('load', () => {
      navigator.serviceWorker.register('service-worker.js').catch(() => {});
    });
  }
};

loadInitialState();
registerServiceWorker();
