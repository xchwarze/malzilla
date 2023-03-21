Changelog:

+ Add a User's Manual to the Docs folder
+ Rewrite of Misc Decoders
+ Rewrite of saving project's data
+ Added some additional data into HTTP response field (see Settings > Download to activate this option)

Known bugs:
- HTTPS protocol not working on Windows XP SP3


23.10.2008

Some time ago I've released Malzilla 1.0, but I didn't have time to update the web site.
I have also uploaded a tool to extract and decompress zlib streams from PDF files.
Now I have uploaded Malzilla 1.1.0.
There is some bugfixes, and a lot of major additions (shellcode analyzer, XOR key search, disassembler etc).
Now I just need to spend some time on writing a couple of tutorials, and a help file would not be bad at all :)


Now, as there is more than a year from the first file release for Malzilla, let's see some kind of report:

- downloads of binary release: 6500
- downloads of source code: 870
- page visits: > 170.000
- hits on Google: > 3000
- donations: 0$

Not bad :)

24.03.2008

New upload - Malzilla 0.9.2.4. The number of additions and changes is pretty long.
Also take a look at the new tutorials on Documents page.

08.03.2008

Please check the download page at SourceForge. I've uploaded two more snapshots after my last post here.
Also, I would like to say thanks to all the people who helped the development of Malzilla.

Most active discussion about Malzilla is taking place here:
http://www.malwaredomainlist.com/forums/index.php?topic=218.0

If you are interested in web-based malware, you will also want to take a look at following sites/projects:
http://www.it-mate.co.uk/
http://www.jimmyleo.com/work/
http://www.fiddlertool.com/fiddler/

Join the fight!

10.02.2008

Uploading 0.9.3 pre-release. Why a pre-release? Well, I have some kind of roadmap, and version 0.9.3 should be multi-lingual.
We need a pre-release to test this functionality, and to polish it for 0.9.3 release.
There is a lot of other things fixed, added and removed if compared to 0.9.2.1.
If anyone is interested in translating Malzilla to other languages, please send me an email.
This upload contains a translating tool (also not final version), so you can check how your translation/language fits in Malzilla.
That would let us know which buttons/labels are to small for particular languages, and also I can eventually implement font size settings if needed.

10.10.2007 (a couple of hours later)

Fixed and uploaded as 0.9.2.1

10.10.2007

Latest  release is broken, don't bother to download. Will fix it ASAP.

09.10.2007

Version 0.92 is out. See the download page for changelog.
Also take a look at Documents page for new tutorials.

07.09.2007

New webpage layout, thanks to Bojan aka SerbianGhost.

Some initial port to Lazarus/FreePascal is done. Downloader and SpiderMonkey are working well. Some of the decoders on Misc Decoders tab are still to be done. Main problem is Unicode support and Word Wrap. This will take some time.

Other main problem is Arguments.callee.toString function and it's differences between Spider Monkey and Internet Explorer:

http://isc.sans.org/diary.html?storyid=3231
http://isc.sans.org/diary.html?storyid=3219
http://isc.sans.org/diary.html?storyid=1519

This one will need some hacking of SpiderMonkey to get it working like Internet Explorer. It will be a real pain, as my C++ is at the level of "Hello world"...

There is some more hacking of SpiderMonkey planned if I succeed in learning some C++.

Happy hunting,
Boban Spasic aka bobby
