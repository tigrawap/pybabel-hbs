PyBabel-HBS
===============

- Extension for babel to support handlebars.
- Uses native Handlebars.js parsing with small hack for passing line numbers.
- **Since Handlebars.js is JS this extension requires node.js**

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

        {{#ntrans num_to_check_aganst params_1="something" num=num_to_check_against}}
            Some text to be translated with %(param_1)s and %(num)s
        {{else}}
            Some plural text to be translated with %(param_1)s and %(num)s
        {{/ntrans}}


*Summarizing*::
    - Every helper can have params which will be passed to sprintf
    - *n_* and *ntrans* helpers MUST have some integer as first parameter, it will determine if plural or singular form should be used