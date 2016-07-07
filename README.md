Meme API
========
An API and TikTokBot integration that implements a !meme command to generate a meme image

Usage
=====

You can explicitly invoke the meme generator from Slack or IRC by saying `!meme ...`

The top text is the message before the first '.' is encountered. Unless there is no '.', then all of the text is put on the bottom of the image. You can also explicitly set the top and bottom text by separating with `|`.

The default image is the Aliens guy if no image is specified:

<img src="api/public/img/aliens.jpg" height="105" width="120" />

You can override the default image by putting an image url or search term after the message surrounded by <code>[]</code>.

Examples
========
<code>!meme I don't always test my code. | But when I do, I do it in production [http://meme.loqi.me/img/most_interesting.jpg]</code>

<img src="http://meme.loqi.me/m/4i9RPWcG.jpg" width="200" />

<code>!meme Top | Bottom [http://meme.loqi.me/img/most_interesting.jpg]</code>

<code>!meme Top | Bottom [largest bunny]</code>

Auto-detecting memes
====================

Certain sentences will be auto-matched according to the regexes in [memes.json](api/memes.json), and memes will be created without explicitly using the <code>!meme</code> command.

Feel free to add new meme templates to the config!

