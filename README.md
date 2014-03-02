zenircbot-meme
==============
A zenircbot service that implements a !meme command to generate a meme img

Usage
=====
Top text is filled with message before the first '.' is encountered. Unless there is no '.', then all of the text is put on the bottom of the image.

Default image is the Aliens guy:

<img src="api/public/img/aliens.jpg" height="105" width="120" />

You can override the default image by putting an image url or search term after the message surrounded by <code>[]</code>.

Examples
========
<code>!meme I don't always test my code. | But when I do, I do it in production [http://memecaptain.com/most_interesting.jpg]</code>

<img src="http://memecaptain.com/8eba0c.jpg" width="200" />

<code>!meme Top | Bottom [http://memecaptain.com/most_interesting.jpg]</code>

<code>!meme Top | Bottom [largest bunny]</code>

Auto-detecting memes
====================

Certain sentences will be auto-matched according to the regexes in [config.js](config.js), and memes will be created without explicitly using the <code>!meme</code> command.

Feel free to add new meme templates to config.js!


Note
====
The service will also send topic messages to the !meme command on topic change, if your version of zenircbot supports it.
I have a fork of it on my github, which supports it, and will update here after I send a pull request to wraithan.

Also it uses http://memecaptain.com for the meme genereation. You could theoretically run that on your own server using https://github.com/mmb/meme_captain
