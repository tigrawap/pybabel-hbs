PyBabel-HBS
===============

Release notes
--------------
- 0.2.1 - Great speed improvement (x4) by moving file reading to nodejs.
- 0.2.0 - Now only one nodejs process spawned for single babel run, so in total for big amount of files will work much faster.
- 0.1.4 - minor bugfixes
- 0.1.3 - Initial release

Installation
--------------
pip install pybabel-hbs

Usage
-------
Add `[hbs: path/\*\*.hbs]` to babel.cfg

Expected workflow
------------------

1. Use helpers inside handlebar (gettext/ngettext as both regular and block heleprs supported)
#. JS side should pass data to Jed wrapper (see client_side_usage)
#. Jed wrapper passes the strings and parameters to Jed
#. Jed instance translates string to language it was initiated with
#. Jed uses po2json output (use po2json on generated .po files and then pass output to Jed)
#. As for generating .po files just add `[hbs: \*\*.hbs]` to babel config (babel.cfg), (considering extension installed via pip or via setup.py install)

- Extension for babel to support handlebars.
- Uses native Handlebars.js parsing with small hack for passing line numbers.
- **Since Handlebars.js is JS this babel extension requires node.js**

Supported handlebars helpers:
--------------------------------

    - _ (Undercore) helper ::

         {{_ "Some text to be translated %(param)s" param="some param"}}

    - \n_ helper ::

         {{\n_ num_to_check_against "Some text to be translated with %(num)s" "Some plural text to be translated with %(num)s" num=num_to_check_against}}

    - trans block helper::

        {{#trans params_1="something"}}
            Some text to be translated with %(param_1)s
        {{/trans}}

    - ntrans block helper::

        {{#ntrans num_to_check_aganst param_1="something" num=num_to_check_against}}
            Some text to be translated with %(param_1)s and %(num)s
        {{else}}
            Some plural text to be translated with %(param_1)s and %(num)s
        {{/ntrans}}


*Summarizing*
---------------
    - Every helper can have params, they will be passed to sprintf (built-in into Jed)
    - *n_* and *ntrans* helpers MUST have some integer as first parameter, it will determine if plural or singular form should be used