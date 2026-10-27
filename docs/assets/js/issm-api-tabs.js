/**
 * Builds MATLAB/Python tabs for every .issm-api-tabs on the page.
 * 
 * Example Markup:
 * 
 *   <div class="api-tabs">
 *     <div class="api-tab" data-api="mat" markdown="1">
 *       Some text content we use to introduce the actual code.
 *       ```mat
 *       This will get styled as MATLAB script as usual.
 *       ```
 *       One of these tabs might also contain a configuration script specific 
 *       to one of the APIs,
 *       ```sh
 *       This will get styled as shell script as usual.
 *       ```
 *       You could even include images or other HTML/Markdown elements.
 *     </div>
 *     <div class="api-tab" data-api="py" markdown="1">
 *       Some text content we use to introduce the actual code.
 *       ```py
 *       This will get styled as Python script as usual.
 *       ```
 *       One of these tabs might also contain a configuration script specific 
 *       to one of the APIs,
 *       ```sh
 *       This will get styled as shell script as usual.
 *       ```
 *       You could even include images or other HTML/Markdown elements.
 *     </div>
 *   </div>
 *
 * NOTE:
 * - .api-tab must have attribute markdown="1" or included Markdown will not be 
 *   rendered as intended.
 */
( function () {
  const API_ALIASES = {
    mat: [ 'mat', 'matlab' ],
    py: [ 'py', 'python' ],
  };

  const LOCAL_STORAGE_KEYS = {
    activeApi: 'active-issm-api',
  };

  const TAB_LABELS = {
    mat: 'MATLAB',
    py: 'Python',
  };

  const TABS_SELECTOR = '.issm-api-tabs';

  const apiByAlias = Object.fromEntries(
    Object.entries( API_ALIASES ).flatMap( ( [ api, aliases ] ) =>
      aliases.map( alias => [ alias, api ] )
    )
  );

  function normalizeApi( api ) {
    return apiByAlias[ api ];
  }

  function processTabs( tabs ) {
    const tabsByApi = [ ...tabs.querySelectorAll( ':scope > .tab' ) ];

    // Convert aliases such as "matlab" and "python" to "mat" and "py".
    tabsByApi.forEach( tab => {
      const api = normalizeApi( tab.dataset.api );

      if ( api ) {
        tab.dataset.api = api;
      }
    } );

    // Require at least one tab for each canonical API.
    const hasOneTabForEachApi = Object.keys( API_ALIASES ).every( api =>
      tabsByApi.some( tab => tab.dataset.api === api )
    );

    if ( !hasOneTabForEachApi ) {
      return;
    }

    const tabBar = document.createElement( 'div' );
    tabBar.className = 'tab-bar';

    tabsByApi.forEach( tab => {
      const api = tab.dataset.api;
      const btn = document.createElement( 'button' );

      btn.type = 'button';
      btn.dataset.api = api;
      btn.textContent = TAB_LABELS[ api ];
      btn.addEventListener( 'click', function () {
        showApiTab( api );
      } );

      tabBar.appendChild( btn );
    } );

    tabs.insertBefore( tabBar, tabs.firstChild );
  }

  function showApiTab( api ) {
    api = normalizeApi( api ) || api;

    document.querySelectorAll( TABS_SELECTOR ).forEach( function ( apiTabs ) {
      apiTabs.querySelectorAll( '[data-api]' ).forEach( function ( apiTabEl ) {
        apiTabEl.classList.toggle( 'active', apiTabEl.dataset.api === api );
      } );
    } );

    try {
      localStorage.setItem( LOCAL_STORAGE_KEYS.activeApi, api );
    } catch ( e ) {
      // Do nothing.
    }
  }

  function init() {
    let saved = null;

    try {
      saved = localStorage.getItem( LOCAL_STORAGE_KEYS.activeApi );
    } catch ( e ) {
      // Do nothing.
    }

    document.querySelectorAll( TABS_SELECTOR ).forEach( processTabs );

    showApiTab( normalizeApi( saved ) || 'mat' );
  }

  // Main
  if ( document.readyState === 'loading' ) {
    document.addEventListener( 'DOMContentLoaded', init );
  } else {
    init();
  }
} )();
