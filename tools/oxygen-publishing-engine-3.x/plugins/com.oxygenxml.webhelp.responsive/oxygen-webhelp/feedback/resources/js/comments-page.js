/**
 * Load the libraries for the DITA topics pages.
 */
define(["require", "feedback_config"], function() {
    require([
        'jquery',
        'whf_config',
        'bootstrap',
        'debug',
        'parseuri',
        'strings',
        'init',
        'comments-functions'
    ]);
});