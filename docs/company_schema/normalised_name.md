---
---
To do when working on new jurisdiction or new company_type spotted in the qa.

  - include examples of common company formation type suffixes or prefixes (eg LTD / LIMITED)
  - if suffixes are included in both full and shortened forms, calculate which one is most popular (eg LTD 22%, LIMITED 78%) and include transformation in the importer
  - see [default regular expressions](https://github.com/openc/openc/blob/master/lib/openc_normaliser.rb#L41)
  - Some of the suffixes are already [dealt with globally](https://github.com/openc/openc/blob/master/config/initializers/constants.rb)
  - ignore any trailing characters that are not part of the suffix.
    - eg ''"ABC LTD"'' - ignore closing ''"''
    - eg ''ABC LTD.'' - don't ignore ''.''
