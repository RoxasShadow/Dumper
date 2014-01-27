Dumper
======

A dumper to download whole image galleries of the most popular boards (aka, those I care).
It's fully modular, so you can add a website just putting its module in lib/dumper/profiles.

Install
=======

`gem install image-dumper`

Profiles
========

Profiles are the scripts that handle the dump of a website.
They are divided in the following types and are useful to understand how to give them the `--from` and `--to` parameters.

- `images`   A page containing a bunch of images. You can choose how many images it has to dump.
- `pages`    You can choose how many pages it has to dump and you will get all the images present on each page.
- `chapters` It will dump a specific chapter of a manga.

Examples
=======

`dumper --list # list profiles`

`dumper --help # show the help and all the available commands`

`dumper -i 4chan # show all the info available for the given profile`

`dumper -u "http://boards.4chan.org/wg/res/5280736" -p "images/"`

`dumper --url "http://www.mangaeden.com/en-manga/nisekoi" --path manga/nisekoi --from 3 --to 9`

`dumper --url "http://www.mangaeden.com/en-manga/nisekoi" --path manga/nisekoi --from 10 --to 10`

`dumper --file stuff.txt # dump all the lines formatted in the "URL||PATH" way`