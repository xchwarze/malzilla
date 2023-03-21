# Malzilla

Web pages that contain exploits often use a series of redirects and obfuscated code to make it more difficult for somebody to follow. MalZilla is a useful program for use in exploring malicious pages. It allows you to choose your own user agent and referrer, and has the ability to use proxies. It shows you the full source of webpages and all the HTTP headers. It gives you various decoders to try and deobfuscate javascript aswell.


## About this repo

This is a versioned copy of the original project.
If someone wants to revive the project maybe this repo is a good starting point.


## Compile notes

From original readme:

```
The following components/units are needed for compiling Malzilla:

- Synapse (http://synapse.ararat.cz/index.htm) - files can be redistributed with Malzilla:
http://sourceforge.net/mailarchive/forum.php?thread_name=46C5CE2D.9010304%40gmail.com&forum_name=synalist-public

- JavaScript Bridge (http://delphi.mozdev.org/) - redistributed with Malzilla; same license
- JVCL (http://homepages.codegear.com/jedi/jvcl/)
- THREFParser (http://iedcomp.nm.ru/)
- THyperParse (http://www.wakproductions.com/) - files needs to be copied into "used_units" folder
- Unicode SynEdit (http://mh-nexus.de/unisynedit.htm)
- ThkClipboardMonitor (http://runner.hit.bg)
- TMPHexEditor (http://www.mirkes.de/en/delphi/vcls/hexedit.php)
- MD5.pas unit (http://www.fichtner.net/delphi/md5/  - not available anymore) - files needs to be copied into "used_units" folder


**************************Important**************************

http://www.paranoia.clara.net/articles/delphi4_lizard_taming.html  -  go to topic Floating Point Exceptions

How it is solved in Malzilla:
- make a copy of original dialogs.pas and put it in Malzilla's "uesd_units" folder under the name dialogsA.pas
- apply the hack mentioned in the article

DO NOT apply the hack on the original file, as the compiler will search for dialogsA.pas, not for dialogs.pas


For any questions: spasic@gmail.com (use proper Subject tag for mails)
```
